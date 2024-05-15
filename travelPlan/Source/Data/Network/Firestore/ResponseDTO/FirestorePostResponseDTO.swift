//
//  FirestorePostResponseDTO.swift
//  travelPlan
//
//  Created by 양승현 on 4/30/24.
//

import Foundation
import FirebaseFirestore

struct FirestorePostResponseDTO: Decodable {
  let authorId: String
  let postId: String

  let startDate: Timestamp
  let endDate: Timestamp
  
  let title: String
  let content: [FirestorePostContentResponseDTO]
  let postImageFiles: [FirestorePostImageFileResponseDTO]
  
  let createAt: Timestamp
  let likes: Int
  let comments: Int
  
  let mapX: Double
  let mapY: Double
  
  let themes: [String]
  let regions: [String]
  let seasons: [String]
  let partners: [String]
  
  enum CodingKeys: String, CodingKey {
    case authorId
    case postId
    case startDate
    case endDate
    case title
    case content
    case postImageFiles = "imgFileList"
    case createAt
    case likes = "likeNum"
    case mapX
    case mapY
    case themes
    case regions
    case seasons
    case partners = "companions"
    case comments = "commentNum"
  }
}

struct FirestorePostContentResponseDTO: Decodable {
  let sort: Int
  let text: String
  
  // MARK: - Mappings DTO
  func toDomain() -> Post.PostContent {
    return .init(sort: sort, text: text)
  }
}

struct FirestorePostImageFileResponseDTO: Decodable {
  let sort: Int
  let url: String
  let imageType: String
  let thumbnail: Bool
  
  enum CodingKeys: String, CodingKey {
    case sort
    case url = "img"
    case imageType
    case thumbnail
  }
  
  // MARK: - Mappings DTO
  func toDomain(with imageData: Data) -> Post.PostImage {
    return .init(imageData: imageData, sort: Int32(sort))
  }
}

// MARK: - Mappings DTO
extension FirestorePostResponseDTO {
  func toDomain() -> Post.Detail<[Post.PostContent]> {
    return Post.Detail(
      postID: postId,
      title: title,
      content: content.map { $0.toDomain() },
      likes: Int32(likes),
      comments: Int32(comments),
      location: .init(x: mapX, y: mapY),
      createAt: DateTimeConverter.toDate(from: createAt),
      tripDate: .init(startDate: DateTimeConverter.toDate(from: startDate),
                      endDate: DateTimeConverter.toDate(from: endDate)))
  }
  
  func toDomain(liked: Bool?, authorImageData: Data?, authorName: String, postImages: [Post.PostImage]) -> Post {
    return .init(
      liked: liked,
      detail: toDomain(),
      author: toDomain(with: authorImageData, authorName: authorName),
      highResolveImages: postImages,
      category: toDomain())
  }
  
  func toDomain(with authorImageData: Data?, authorName: String) -> Post.Author {
    return .init(
      profileImageData: authorImageData,
      nickname: authorName,
      authorId: authorId)
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
  
  func toDomain(postImages: [Post.PostImage]) -> AtomicPost {
    return AtomicPost(
      authorId: authorId,
      detail: toDomain(),
      category: toDomain(),
      highResolveImages: postImages)
  }
}
