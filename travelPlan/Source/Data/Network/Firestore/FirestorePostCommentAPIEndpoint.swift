//
//  FirestorePostCommentAPIEndpoint.swift
//  travelPlan
//
//  Created by 양승현 on 5/4/24.
//

import Foundation

struct FirestorePostCommentAPIEndpoint {
  typealias CommentId = String
  
  static func makeCommentSendEndpoint(
    postId: String,
    commentId: CommentId,
    with requestDTO: FirestorePostCommentSendRequestDTO
  ) -> FirestoreEndpoint<CommentId> {
    return FirestoreEndpoint(
      requestDTO: requestDTO,
      method: .save(commentId),
      requestType: .posts(.saveComment(postId, commentId)))
  }
}
