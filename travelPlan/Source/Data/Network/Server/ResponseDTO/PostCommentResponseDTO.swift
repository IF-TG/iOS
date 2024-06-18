//
//  PostCommentResponseDTO.swift
//  travelPlan
//
//  Created by 양승현 on 3/23/24.
//

import Foundation

struct PostCommentResponseDTO: Decodable {
  let commentId: CommentIdentifier
  let authorId: UserIdentifier
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
    // TODO: - 서버에서 authorId api에 추가하면 해당 key로 대응해야 합니다.
    case authorId
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
  func toDomain(with commentAuthorImageData: Data?, nestedCommentAuthorsImageData: [Data?]) -> PostCommentEntity {
    return PostCommentEntity(
      commentId: commentId, 
      authorId: authorId,
      userProfileImageData: commentAuthorImageData,
      userName: nickname,
      timestamp: timestamp,
      comment: comment,
      isDeleted: isDeleted,
      isOnHeart: isOnHeart,
      isBlocked: isBlocked,
      hearts: hearts,
      nestedComments: nestedComments.enumerated().map { $1.toDomain(with: nestedCommentAuthorsImageData[$0] ) })
  }
}
