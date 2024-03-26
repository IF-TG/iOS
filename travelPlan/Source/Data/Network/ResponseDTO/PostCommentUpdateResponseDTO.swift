//
//  PostCommentUpdateResponseDTO.swift
//  travelPlan
//
//  Created by 양승현 on 3/24/24.
//

import Foundation

struct PostCommentUpdateResponseDTO: Decodable {
  let commentId: Int64
  let comment: String
}

// MARK: - Mappings to Domain
extension PostCommentUpdateResponseDTO {
  func toDomain() -> UpdatedPostCommentEntity {
    return UpdatedPostCommentEntity(
      commentId: commentId,
      comment: comment)
  }
}
