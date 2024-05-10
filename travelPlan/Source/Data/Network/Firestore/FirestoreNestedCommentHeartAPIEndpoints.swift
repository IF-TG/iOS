//
//  FirestoreNestedCommentHeartAPIEndpoints.swift
//  travelPlan
//
//  Created by 양승현 on 5/10/24.
//

import Foundation

struct FirestoreNestedCommentHeartAPIEndpoints {
  typealias UserIdentifier = String
  private init() {}
  
  static func makeNestedCommentHeartUsersFetchEndpoint(
    withPostId postId: String,
    commentId: String,
    nestedCommentId: String
  ) -> FirestoreEndpoint<[UserIdentifier]> {
    return FirestoreEndpoint(
      method: .get,
      requestType: .posts(.fetchNestedCommentHeartUsers(postId, commentId, nestedCommentId)))
  }
  
  static func makeNestedCommentHeartEndpoint(
    withPostId postId: String,
    commentId: String,
    nestedCommentId: String,
    userId: String
  ) -> FirestoreEndpoint<UserIdentifier> {
    return FirestoreEndpoint(
      method: .save(userId),
      requestType: .posts(.heartNestedComment(postId, commentId, nestedCommentId)))
  }
}
