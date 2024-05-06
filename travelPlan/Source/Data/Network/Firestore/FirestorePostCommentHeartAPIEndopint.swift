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
    _ postId: String,
    _ commentId: String
  ) -> FirestoreEndpoint<[UserIdentifier]> {
    return FirestoreEndpoint(
      method: .retrieveDocumentIdList,
      requestType: .posts(.fetchCommentHeartUsers(postId, commentId)))
  }
  
  static func makeCommentHeartEndpoint(
    _ postId: String,
    _ commentId: String,
    _ userId: String
  ) -> FirestoreEndpoint<UserIdentifier> {
    return .init(
      method: .save(userId),
      requestType: .posts(.heartComment(postId, commentId)))
  }
}
