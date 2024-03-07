//
//  PostResponseDTO.swift
//  travelPlan
//
//  Created by 양승현 on 3/6/24.
//

import Foundation

struct PostResponseDTO: Decodable {
  // MARK: - Properties
  let postID: Int64
  let postImages: [PostImage]
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
    case title
    case content
    case likes = "likeNum"
    case comments = "commentNum"
    case location
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
    self.postID = try container.decode(Int64.self, forKey: .postID)
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
    
    func toDomain() -> Post.PostImage {
      return .init(imageUri: image, sort: sort)
    }
  }
}



// MARK: - Mappings DTO
extension PostResponseDTO {
  func toDomain() -> Post.PostDetail {
    return Post.PostDetail(
      postID: postID,
      title: title,
      postImages: postImages.map { $0.toDomain() },
      content: content,
      likes: likes,
      comments: comments,
      location: toDomain(),
      createAt: createAt,
      tripDate: toDomain())
  }
  
  func toDomain() -> Post.Author {
    .init(profileUri: profile, nickname: nickname)
  }
  
  func toDomain() -> Post.TripDate {
    return .init(start: startDate, end: endDate)
  }
  
  func toDomain() -> Post.Location {
    return .init(x: mapX, y: mapY)
  }
}
