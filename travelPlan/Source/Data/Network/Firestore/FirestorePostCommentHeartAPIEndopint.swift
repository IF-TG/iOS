//
//  FirestorePostCommentHeartAPIEndopint.swift
//  travelPlan
//
//  Created by 양승현 on 5/6/24.
//

import Foundation

struct FirestorePostCommentHeartAPIEndopint {
  typealias UserIdentifier = String
  static func makeCommentHeartUsersFetchEndpoint(
    with postId: String,
    commentId: String
  ) -> FirestoreEndpoint<[UserIdentifier]> {
    return FirestoreEndpoint(
      method: .retrieveDocumentIdList,
      requestType: .posts(.fetchCommentHeartUsers(postId, commentId)))
  }
  
  static func makeCommentHeartEndpoint(
    with postId: String,
    commentId: String,
    userId: String
  ) -> FirestoreEndpoint<UserIdentifier> {
    return .init(
      method: .save(userId),
      requestType: .posts(.heartComment(postId, commentId)))
  }
  
  static func makeCommentHateEndpoint(
    with postId: String,
    commentId: String,
    userId: String
  ) -> FirestoreEndpoint<VoidResponseDTO> {
    return .init(
      method: .delete,
      requestType: .posts(.hateComment(postId, commentId, userId)))
  }
  
  static func makePostHeartsToggleEndpoint(
    with postId: String,
    commentId: String
  ) -> FirestoreEndpoint<VoidResponseDTO> {
    return.init(
      method: .update,
      requestType: .posts(.toggleCommentHeart(postId, commentId)))
  }
}
