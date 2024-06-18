//
//  FirestoreNestedCommentHeartAPIEndpoints.swift
//  travelPlan
//
//  Created by 양승현 on 5/10/24.
//

import Foundation

struct FirestoreNestedCommentHeartAPIEndpoints {
  private init() {}
  
  static func makeNestedCommentHeartUsersFetchEndpoint(
    withPostId postId: PostIdentifier,
    commentId: CommentIdentifier,
    nestedCommentId: NestedCommentIdentifier
  ) -> FirestoreEndpoint<[String]> {
    return FirestoreEndpoint(
      method: .retrieveDocumentIdList,
      requestType: .posts(.fetchNestedCommentHeartUsers(postId, commentId, nestedCommentId)))
  }
  
  static func makeNestedCommentHeartEndpoint(
    withPostId postId: PostIdentifier,
    commentId: CommentIdentifier,
    nestedCommentId: NestedCommentIdentifier,
    userId: UserIdentifier
  ) -> FirestoreEndpoint<UserIdentifier> {
    return FirestoreEndpoint(
      method: .save(String(userId)),
      requestType: .posts(.heartNestedComment(postId, commentId, nestedCommentId)))
  }
  
  static func makeNestedCommentHateEndpoint(
    withPostId postId: PostIdentifier,
    commentId: CommentIdentifier,
    nestedCommentId: NestedCommentIdentifier,
    userId: UserIdentifier
  ) -> FirestoreEndpoint<VoidResponseDTO> {
    return FirestoreEndpoint(
      method: .delete,
      requestType: .posts(.hateNestedComment(postId, commentId, nestedCommentId, userId)))
  }
  
  static func makeNestedCommentHeartsUpdateEndpoint(
    withPostId postId: PostIdentifier,
    commentId: CommentIdentifier,
    nestedCommentId: NestedCommentIdentifier
  ) -> FirestoreEndpoint<VoidResponseDTO> {
    return FirestoreEndpoint(
      method: .update,
      requestType: .posts(.updateNestedCommentHearts(postId, commentId, nestedCommentId)))
  }
  
  /// 대댓글 개수 받아오기
  static func makeNestedCommentHeartsFetchEndpoint(
    withPostId postId: PostIdentifier,
    commentId: CommentIdentifier,
    nestedCommentId: NestedCommentIdentifier
  ) -> FirestoreEndpoint<PostNestedCommentHeartsResponseDTO> {
    return FirestoreEndpoint(
      method: .get,
      requestType: .posts(.fetchNestedCommentHearts(postId, commentId, nestedCommentId)))
  }
}
