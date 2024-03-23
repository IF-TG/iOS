//
//  PostCommentResponseDTO.swift
//  travelPlan
//
//  Created by 양승현 on 3/23/24.
//

import Foundation

struct PostCommentResponseDTO: Decodable {
  let commentId: Int64
  let userProfileURL: String
  let nickname: String
  let timestamp: String
  let comment: String
  let isDeleted: Bool
  let isOnHeart: Bool
  let hearts: Int32
  let isBlocked: Bool
  let nestedComments: [PostNestedCommentResponseDTO]
  
  enum CodingKeys: String, CodingKey {
    case commentId
    case userProfileURL = "profileImgUri"
    case nickname
    case timestamp = "createAt"
    case comment
    case isDeleted = "deleted"
    case isOnHeart = "liked"
    case hearts = "likeNum"
    case isBlocked = "blocked"
    case nestedComments = "nestedCommentDtoList"
  }
  
  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.commentId = try container.decode(Int64.self, forKey: .commentId)
    self.userProfileURL = try container.decode(String.self, forKey: .userProfileURL)
    self.nickname = try container.decode(String.self, forKey: .nickname)
    self.timestamp = try container.decode(String.self, forKey: .timestamp)
    self.comment = try container.decode(String.self, forKey: .comment)
    self.isDeleted = try container.decode(Bool.self, forKey: .isDeleted)
    self.isOnHeart = try container.decode(Bool.self, forKey: .isOnHeart)
    self.hearts = try container.decode(Int32.self, forKey: .hearts)
    self.isBlocked = try container.decode(Bool.self, forKey: .isBlocked)
    self.nestedComments = try container.decode([PostNestedCommentResponseDTO].self, forKey: .nestedComments)
  
  }
}

// MARK: - Mappings to Domain
extension PostCommentResponseDTO {
  func toDomain() -> PostCommentEntity {
    return PostCommentEntity(
      commentId: commentId,
      userProfileURL: userProfileURL,
      userName: nickname,
      timestamp: timestamp,
      comment: comment,
      isDeleted: isDeleted,
      isOnHeart: isOnHeart,
      isBlocked: isBlocked,
      hearts: hearts,
      nestedComments: nestedComments.map { $0.toDomain() })
  }
}
