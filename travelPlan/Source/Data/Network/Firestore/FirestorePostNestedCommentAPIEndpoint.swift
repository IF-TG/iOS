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
      requestType: .posts(.saveNestedComment(postId, commentId)))
  }
  
  static func makeNestedCommentDeleteEndpoint(
    withPostId postId: String,
    commentId: String,
    nestedCommentId: String
  ) -> FirestoreEndpoint<VoidResponseDTO> {
    return FirestoreEndpoint(
      method: .delete,
      requestType: .posts(.deleteNestedComment(postId, commentId, nestedCommentId)))
  }
  
  static func makeNestedCommentUpdateEndpoint(
    withPostId postId: String,
    commentId: String,
    nestedCommentId: String,
    requestDTO: PostNestedCommentUpdateRequestDTO
  ) -> FirestoreEndpoint<VoidResponseDTO> {
    return FirestoreEndpoint(
      requestDTO: requestDTO,
      method: .update,
      requestType: .posts(.updateNestedComment(postId, commentId, nestedCommentId)))
  }
  
  static func makeNestedCommentsFetchEndpoint(
    withPostId postId: String,
    commentId: String
  ) -> FirestoreEndpoint<[PostAtomicNestedCommentResponseDTO]> {
    return FirestoreEndpoint(
      method: .get,
      requestType: .posts(.fetchNestedComments(postId, commentId)))
  }
}
