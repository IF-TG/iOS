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
