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
  
  static func makeCommentUpdateEndpoint(
    postId: String,
    with requestDTO: PostCommentUpdateRequestDTO
  ) -> FirestoreEndpoint<VoidResponseDTO> {
    return FirestoreEndpoint(
      requestDTO: requestDTO,
      method: .update,
      requestType: .posts(.updateComment(postId, requestDTO.commentId)))
  }
  
  /// NestedComment가 없는 경우
  static func makeCommentDeleteEndpoint(
    postId: String,
    commentId: CommentId
  ) -> FirestoreEndpoint<VoidResponseDTO> {
    return FirestoreEndpoint(
      method: .delete,
      requestType: .posts(.deleteComment(postId, commentId)))
  }
  
  /// NestedComment가 있는 경우
  static func makeCommentDeleteWhenNestedCommentExistEndpoint(
    postId: String,
    commentId: String
  ) -> FirestoreEndpoint<VoidResponseDTO> {
    let requestDTODict = ["hasDeleted": true]
    return FirestoreEndpoint(
      requestDTODict: requestDTODict,
      method: .update,
      requestType: .posts(.deleteCommentWhenNestedCommentExists(postId, commentId)))
  }
  
  static func makeCommentsFetchEndpoint(
    postId: String
  ) -> FirestoreEndpoint<FirestorePostCommentResponseDTO> {
    return FirestoreEndpoint(
      method: .get,
      requestType: .posts(.fetchComments(postId)))
  }
}
