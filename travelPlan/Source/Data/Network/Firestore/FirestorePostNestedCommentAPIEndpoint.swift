//
//  FirestorePostNestedCommentAPIEndpoint.swift
//  travelPlan
//
//  Created by 양승현 on 5/7/24.
//

import Foundation

struct FirestorePostNestedCommentAPIEndpoint {
  static func makeNestedCommentSendEndpoint(
    withPostId postId: PostIdentifier,
    commentId: CommentIdentifier,
    nestedCommentId: NestedCommentIdentifier,
    requestDTO: FirestorePostNestedCommentSendRequestDTO
  ) -> FirestoreEndpoint<NestedCommentIdentifier> {
    return FirestoreEndpoint(
      requestDTO: requestDTO,
      method: .save(String(nestedCommentId)),
      requestType: .posts(.saveNestedComment(postId, commentId)))
  }
  
  static func makeNestedCommentDeleteEndpoint(
    withPostId postId: PostIdentifier,
    commentId: CommentIdentifier,
    nestedCommentId: NestedCommentIdentifier
  ) -> FirestoreEndpoint<VoidResponseDTO> {
    return FirestoreEndpoint(
      method: .delete,
      requestType: .posts(.deleteNestedComment(postId, commentId, nestedCommentId)))
  }
  
  static func makeNestedCommentUpdateEndpoint(
    withPostId postId: PostIdentifier,
    commentId: CommentIdentifier,
    nestedCommentId: NestedCommentIdentifier,
    requestDTO: PostNestedCommentUpdateRequestDTO
  ) -> FirestoreEndpoint<VoidResponseDTO> {
    return FirestoreEndpoint(
      requestDTO: requestDTO,
      method: .update,
      requestType: .posts(.updateNestedComment(postId, commentId, nestedCommentId)))
  }
  
  static func makeNestedCommentsFetchEndpoint(
    withPostId postId: PostIdentifier,
    commentId: CommentIdentifier
  ) -> FirestoreEndpoint<[PostAtomicNestedCommentResponseDTO]> {
    return FirestoreEndpoint(
      method: .get,
      requestType: .posts(.fetchNestedComments(postId, commentId)))
  }

  static func makeTheNumberOfNestedCommentsFetchEndpoint(
    withPostId postId: PostIdentifier,
    commentId: CommentIdentifier
  ) -> FirestoreEndpoint<Int> {
    return FirestoreEndpoint(
      method: .retrieveNumberOfDocuments,
      requestType: .posts(.fetchNestedComments(postId, commentId)))
  }
  
  static func makeNestedCommentsAllDeleteEndpoint(
    withPostId postId: PostIdentifier,
    commentId: CommentIdentifier
  ) -> FirestoreEndpoint<VoidResponseDTO> {
    return FirestoreEndpoint(
      method: .deleteACollection,
      requestType: .posts(.deleteAllNestedComments(postId, commentId)))
  }
}
