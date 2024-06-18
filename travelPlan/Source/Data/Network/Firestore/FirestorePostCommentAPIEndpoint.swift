//
//  FirestorePostCommentAPIEndpoint.swift
//  travelPlan
//
//  Created by 양승현 on 5/4/24.
//

import Foundation

struct FirestorePostCommentAPIEndpoint {
  static func makeCommentSendEndpoint(
    postId: PostIdentifier,
    commentId: CommentIdentifier,
    with requestDTO: FirestorePostCommentSendRequestDTO
  ) -> FirestoreEndpoint<CommentIdentifier> {
    return FirestoreEndpoint(
      requestDTO: requestDTO,
      method: .save(String(commentId)),
      requestType: .posts(.saveComment(postId, commentId)))
  }
  
  static func makeCommentUpdateEndpoint(
    postId: PostIdentifier,
    with requestDTO: PostCommentUpdateRequestDTO
  ) -> FirestoreEndpoint<VoidResponseDTO> {
    return FirestoreEndpoint(
      requestDTO: requestDTO,
      method: .update,
      requestType: .posts(.updateComment(postId, requestDTO.commentId)))
  }
  
  /// NestedComment가 없는 경우
  static func makeCommentDeleteEndpoint(
    postId: PostIdentifier,
    commentId: CommentIdentifier
  ) -> FirestoreEndpoint<VoidResponseDTO> {
    return FirestoreEndpoint(
      method: .delete,
      requestType: .posts(.deleteComment(postId, commentId)))
  }
  
  /// NestedComment가 있는 경우
  static func makeCommentDeleteWhenNestedCommentExistEndpoint(
    postId: PostIdentifier,
    commentId: CommentIdentifier
  ) -> FirestoreEndpoint<VoidResponseDTO> {
    let requestDTODict = ["hasDeleted": true]
    return FirestoreEndpoint(
      requestDTODictionary: requestDTODict,
      method: .update,
      requestType: .posts(.deleteCommentWhenNestedCommentExists(postId, commentId)))
  }
  
  static func makeCommentsFetchEndpoint(
    postId: PostIdentifier
  ) -> FirestoreEndpoint<FirestorePostCommentResponseDTO> {
    return FirestoreEndpoint(
      method: .get,
      requestType: .posts(.fetchComments(postId)))
  }
}
