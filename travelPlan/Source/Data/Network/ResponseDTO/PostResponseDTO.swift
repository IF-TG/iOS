//
//  PostResponseDTO.swift
//  travelPlan
//
//  Created by 양승현 on 3/6/24.
//

import Foundation

struct PostResponseDTO: Decodable {
  // MARK: - Properties
  let author: Author
  let category: Category
  let postDetail: PostDetail
  let liked: Bool
  
  enum CodingKeys: String, CodingKey {
    case author
    case category
    case postDetail
    case liked
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.author = try container.decode(PostResponseDTO.Author.self, forKey: .author)
    self.category = try container.decode(PostResponseDTO.Category.self, forKey: .category)
    self.postDetail = try container.decode(PostResponseDTO.PostDetail.self, forKey: .postDetail)
    self.liked = try container.decode(Bool.self, forKey: .liked)
  }
}

// MARK: - Nested
extension PostResponseDTO {
  struct PostDetail: Decodable {
    let postID: Int64
    let postImages: [PostImage]
    let title: String
    let content: String
    let likes: Int32
    let comments: Int32
    let location: Location
    let createAt: String
    let tripDate: TripDate
    
    enum CodingKeys: String, CodingKey {
      case postImages
      case postID = "postId"
      case title
      case content
      case likes = "likeNum"
      case comments = "commentNum"
      case location
      case createAt
      case tripDate
    }
  }
  
  struct PostImage: Decodable {
    let image: String
    let sort: Int32
    
    private enum CodingKeys: String, CodingKey {
      case image = "img"
      case sort
    }
    
    func toDomain() -> Post.PostImage {
      return .init(imageUri: image, sort: sort)
    }
  }
  
  struct Author: Decodable {
    let profile: String
    let nickname: String
    
    private enum CodingKeys: String, CodingKey {
      case profile = "profileImgUri"
      case nickname = "nickname"
    }
  }
  
  struct TripDate: Decodable {
    let start: String
    let end: String
    
    private enum CodingKeys: String, CodingKey {
      case start = "startDate"
      case end = "endDate"
    }
    
    func toDomain() -> Post.TripDate {
      return .init(start: start, end: end)
    }
  }
  
  struct Category: Decodable {
    let themes: [String]
    let regions: [String]
    let seasons: [String]
    let partners: [String]
    
    enum CodingKeys: String, CodingKey {
      case themes
      case regions
      case seasons
      case partners = "companions"
    }
  }
  
  struct Location: Decodable {
    let x: Double
    let y: Double
    
    private enum CodingKeys: String, CodingKey {
      case x = "mapX"
      case y = "mapY"
    }
    
    func toDomain() -> Post.Location {
      return .init(x: x, y: y)
    }
  }
}
