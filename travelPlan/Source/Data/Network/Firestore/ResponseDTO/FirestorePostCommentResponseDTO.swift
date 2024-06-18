//
//  FirestorePostCommentResponseDTO.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/5/24.
//

import Foundation
import FirebaseFirestore

struct FirestorePostCommentResponseDTO: Decodable {
  let authorId: UserIdentifier
  let commentId: CommentIdentifier
  let comment: String
  let createAt: Timestamp
  let hasDeleted: Bool
  let heartNum: Int
}

// MARK: - Mapping domain
extension FirestorePostCommentResponseDTO {
  func toDomain() -> PostAtomicCommentEntity {
    return .init(
      commentId: commentId,
      authorId: authorId,
      comment: comment,
      createAt: createAt.dateValue(),
      hasDeleted: hasDeleted,
      hearts: heartNum)
  }
}
