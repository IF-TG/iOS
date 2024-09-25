//
//  PostResponseDTO.swift
//  travelPlan
//
//  Created by 양승현 on 3/6/24.
//

import Foundation
import os.log

struct PostResponseDTO: Decodable {
  // MARK: - Properties
  let postID: PostIdentifier
  let postImages: [PostImage]
  // TODO: - 서버에서 autourId를 api에 추가하면 반영 CodingKeys에 반영해야합니다.
  let authorId: UserIdentifier
  let title: String
  let content: String
  let likes: Int32
  let comments: Int32
  let mapX: Double
  let mapY: Double
  let createAt: String
  let profile: String
  let nickname: String
  let startDate: String
  let endDate: String
  let themes: [String]
  let regions: [String]
  let seasons: [String]
  let partners: [String]
  let liked: Bool
  
  enum CodingKeys: String, CodingKey {
    case postID = "postId"
    case postImages = "postImgUri"
    case authorId
    case title
    case content
    case likes = "likeNum"
    case comments = "commentNum"
    case createAt
    case profile = "profileImgUri"
    case nickname
    case startDate
    case endDate
    case themes
    case regions
    case seasons
    case partners = "companions"
    case liked
    case mapX
    case mapY
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.postID = try container.decode(PostIdentifier.self, forKey: .postID)
    self.authorId = try container.decode(UserIdentifier.self, forKey: .authorId)
    self.postImages = try container.decode([PostImage].self, forKey: .postImages)
    self.title = try container.decode(String.self, forKey: .title)
    self.content = try container.decode(String.self, forKey: .content)
    self.likes = try container.decode(Int32.self, forKey: .likes)
    self.comments = try container.decode(Int32.self, forKey: .comments)
    self.mapX = try container.decode(Double.self, forKey: .mapX)
    self.mapY = try container.decode(Double.self, forKey: .mapY)
    self.createAt = try container.decode(String.self, forKey: .createAt)
    self.profile = try container.decode(String.self, forKey: .profile)
    self.nickname = try container.decode(String.self, forKey: .nickname)
    self.startDate = try container.decode(String.self, forKey: .startDate)
    self.endDate = try container.decode(String.self, forKey: .endDate)
    self.themes = try container.decode([String].self, forKey: .themes)
    self.regions = try container.decode([String].self, forKey: .regions)
    self.seasons = try container.decode([String].self, forKey: .seasons)
    self.partners = try container.decode([String].self, forKey: .partners)
    self.liked = try container.decode(Bool.self, forKey: .liked)
  }
}

// MARK: - Nested
extension PostResponseDTO {
  struct PostImage: Decodable {
    let image: String
    let sort: Int32
    
    enum CodingKeys: String, CodingKey {
      case image = "img"
      case sort
    }
    
    func toDomain(with data: Data?) -> Post.PostImage {
      return .init(imageData: data, sort: sort)
    }
  }
}

// MARK: - Mappings DTO
extension PostResponseDTO {
  func toDomain() -> Post {
    return .init(
      liked: liked,
      detail: toDomain(),
      author: toDomain(with: Data(base64Encoded: profile)),
      highResolveImages: postImages.map { $0.toDomain(with: Data(base64Encoded: $0.image)) },
      category: toDomain())
  }
  
  func toDomain() -> Post.Detail<[Post.PostContent]> {
    // MARK: - Server에서 받는 글의 경우 특정한 테그에 의해 글을 분리해야합니다.
    // 서버에서 createAt형식을 yyyy.MM.dd형식으로 줘야합니다.
    var createAtDate: Date
    if let date = DateTimeConverter.toDate(from: createAt) {
      createAtDate = date
    } else {
      createAtDate = Date()
      os_log(
        "Failed to convert createAt to Date. PostId: %@ createAt: %@",
        log: .default,
        type: .error,
        postID, createAt)
    }
    
//        os_log(
//          "Failed to convert trip dates. PostId: %@ Start Date: %@, End Date: %@",
//          log: .default,
//          type: .error,
//          postID, startDate, endDate)
    
    let textContents: [Post.PostContent] = indexDelimitedByUUID(content)
    
    return Post.Detail<[Post.PostContent]>(
      postID: postID,
      title: title,
      content: textContents,
      likes: likes,
      comments: comments,
      location: toDomain(),
      createAt: createAtDate,
      tripDate: toDomain())
  }
  
  func toDomain(with authorProfileData: Data?) -> Post.Author {
    .init(profileImageData: authorProfileData, nickname: nickname, authorId: authorId)
  }
  
  func toDomain() -> Post.TripDate {
    let start = DateTimeConverter.toDate(from: startDate)
    let end = DateTimeConverter.toDate(from: endDate)
    if let start, let end {
      return .init(startDate: start, endDate: end)
    }
    os_log(
      "Failed to convert trip dates. PostId: %@ Start Date: %@, End Date: %@",
      log: .default,
      type: .error,
      postID, startDate, endDate)
    return .init(startDate: Date(), endDate: Date())
  }
  
  func toDomain() -> Post.Location {
    return .init(x: mapX, y: mapY)
  }
  
  func toDomain() -> Post.Category {
    let mappedThemes = themes.compactMap { TravelThemeMapper.toDomain($0) }
    let mappedRegions = regions.compactMap { TravelRegionMapper.toDomain($0) }
    let mappedSeasons = seasons.compactMap { SeasonMapper.toDomain($0) }
    let mappedPartners = partners.compactMap { TravelPartnerMapper.toDomain($0) }
    
    return Post.Category(
      themes: mappedThemes,
      regions: mappedRegions,
      seasons: mappedSeasons,
      partners: mappedPartners)
  }
}

// MARK: - Private Helpers
private extension PostResponseDTO {
  func indexDelimitedByUUID(_ contentText: String) -> [Post.PostContent] {
    // UUID 정규 표현식 패턴
    let uuidPattern = "[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}"
    guard let regex = try? NSRegularExpression(pattern: uuidPattern, options: []) else { return [] }
    
    var result = [Post.PostContent]()
    var currentIndex = 1
    var lastPosition = contentText.startIndex
    
    // 정규식으로 매칭된 UUID 위치를 탐색합니다.
    let matches = regex.matches(
      in: contentText, options: [],
      range: NSRange(contentText.startIndex..., in: contentText)
    )
    
    for match in matches {
      let range = Range(match.range, in: contentText)!
      
      // UUID 앞의 텍스트 부분
      let prefixText = String(contentText[lastPosition..<range.lowerBound])
        .trimmingCharacters(in: .whitespacesAndNewlines)
      if !prefixText.isEmpty {
        result.append(Post.PostContent(sort: currentIndex, text: prefixText))
        currentIndex += 1 // 텍스트에 인덱스 추가
      }
      
      currentIndex += 1 // UUID index 추가
      lastPosition = range.upperBound // UUID 뒤의 다음 텍스트로 갱신
    }
    
    // 마지막 남은 텍스트 처리
    let finalText = String(contentText[lastPosition...]).trimmingCharacters(in: .whitespacesAndNewlines)
    if !finalText.isEmpty {
      result.append(Post.PostContent(sort: currentIndex, text: finalText))
    }
    
    return result
  }
}
