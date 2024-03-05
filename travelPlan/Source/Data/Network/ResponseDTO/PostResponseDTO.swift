//
//  PostResponseDTO.swift
//  travelPlan
//
//  Created by 양승현 on 3/6/24.
//

import Foundation

struct PostResponseDTO: Decodable {
  // MARK: - Properties
  let user: User
  let dateInfo: DateInfo
  let postImages: [PostThumbnail]
  let category: Category
  let postID: Int64
  let title: String
  let content: String
  let likes: Int32
  let comments: Int32
  let location: Location
  let liked: Bool
  let sort: String
  
  enum CodingKeys: String, CodingKey {
    case user
    case dateInfo
    case postImages
    case category
    case postID = "postId"
    case title
    case content
    case likes = "likeNum"
    case comments = "commentNum"
    case location
    case liked
    case sort
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.user = try container.decode(PostResponseDTO.User.self, forKey: .user)
    self.dateInfo = try container.decode(PostResponseDTO.DateInfo.self, forKey: .dateInfo)
    self.postImages = try container.decode([PostResponseDTO.PostThumbnail].self, forKey: .postImages)
    self.category = try container.decode(PostResponseDTO.Category.self, forKey: .category)
    self.postID = try container.decode(Int64.self, forKey: .postID)
    self.title = try container.decode(String.self, forKey: .title)
    self.content = try container.decode(String.self, forKey: .content)
    self.likes = try container.decode(Int32.self, forKey: .likes)
    self.comments = try container.decode(Int32.self, forKey: .comments)
    self.location = try container.decode(PostResponseDTO.Location.self, forKey: .location)
    self.liked = try container.decode(Bool.self, forKey: .liked)
    self.sort = try container.decode(String.self, forKey: .sort)
  }
  
}

// MARK: - Nested
extension PostResponseDTO {
  struct PostThumbnail: Decodable {
    let image: String
    let sort: Int32
    
    private enum CodingKeys: String, CodingKey {
      case image = "img"
      case sort
    }
  }
  
  struct User: Decodable {
    let profile: String
    let nickname: String
    
    private enum CodingKeys: String, CodingKey {
      case profile = "profileImgUri"
      case nickname = "nickname"
    }
  }
  
  struct DateInfo: Decodable {
    let createAt: String
    let travelStart: String
    let travelEnd: String
    
    private enum CodingKeys: String, CodingKey {
      case createAt
      case travelStart = "startDate"
      case travelEnd = "endDate"
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
  }
  
}
