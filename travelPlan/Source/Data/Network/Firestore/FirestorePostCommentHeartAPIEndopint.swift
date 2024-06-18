//
//  FirestorePostCommentHeartAPIEndopint.swift
//  travelPlan
//
//  Created by 양승현 on 5/6/24.
//

import Foundation

struct FirestorePostCommentHeartAPIEndopint {
  static func makeCommentHeartUsersFetchEndpoint(
    with postId: PostIdentifier,
    commentId: CommentIdentifier
  ) -> FirestoreEndpoint<[String]> {
    return FirestoreEndpoint(
      method: .retrieveDocumentIdList,
      requestType: .posts(.fetchCommentHeartUsers(postId, commentId)))
  }
  
  static func makeCommentHeartEndpoint(
    with postId: PostIdentifier,
    commentId: CommentIdentifier,
    userId: UserIdentifier
  ) -> FirestoreEndpoint<UserIdentifier> {
    return .init(
      method: .save(String(userId)),
      requestType: .posts(.heartComment(postId, commentId)))
  }
  
  static func makeCommentHateEndpoint(
    with postId: PostIdentifier,
    commentId: CommentIdentifier,
    userId: UserIdentifier
  ) -> FirestoreEndpoint<VoidResponseDTO> {
    return .init(
      method: .delete,
      requestType: .posts(.hateComment(postId, commentId, userId)))
  }
  
  static func makePostHeartsToggleEndpoint(
    with postId: PostIdentifier,
    commentId: CommentIdentifier
  ) -> FirestoreEndpoint<VoidResponseDTO> {
    return.init(
      method: .update,
      requestType: .posts(.updateCommentHearts(postId, commentId)))
  }
  
  static func makeCommentHeartsFetchEndpoint(
    withPostId postId: PostIdentifier,
    commentId: CommentIdentifier
  ) -> FirestoreEndpoint<PostNestedCommentHeartsResponseDTO> {
    return .init(
      method: .get,
      requestType: .posts(.fetchCommentHearts(postId, commentId)))
  }
}
