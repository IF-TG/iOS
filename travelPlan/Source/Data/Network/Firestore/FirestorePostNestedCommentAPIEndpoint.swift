//
//  FirestorePostNestedCommentAPIEndpoint.swift
//  travelPlan
//
//  Created by 양승현 on 5/7/24.
//

import Foundation

struct FirestorePostNestedCommentAPIEndpoint {
  typealias NestedCommentIdentifier = String
  static func makeNestedCommentSendEndpoint(
    withPostId postId: String,
    commentId: String,
    nestedCommentId: String,
    requestDTO: FirestorePostNestedCommentSendRequestDTO
  ) -> FirestoreEndpoint<NestedCommentIdentifier> {
    return FirestoreEndpoint(
      requestDTO: requestDTO,
      method: .save(nestedCommentId),
      requestType: .posts(.saveNestedComment(postId, commentId, nestedCommentId)))
  }
}
