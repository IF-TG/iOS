//
//  PostNotificationManager.swift
//  travelPlan
//
//  Created by 양승현 on 6/15/24.
//

import Foundation

// MARK: - Notification.Name + Post
extension Notification.Name {
  static let hasPostBlocked = Notification.Name("PostBlocked")
  static let postShareFromPostOptionActionSheet = Notification.Name("PostShareFromPostOptionActionSheet")
}

final class PostNotificationManager {
  static let shared = PostNotificationManager()
  
  private init() { }
}

// MARK: - For post option
extension PostNotificationManager {
  func notifyPostHasBlocked(postId: Int32, postOptionLocation: PostOptionLocation) {
    NotificationCenter.default.post(
      name: .hasPostBlocked,
      object: nil,
      userInfo: ["postId": postId,
                 "postOptionLocation": postOptionLocation])
  }
  
  func notifyUserWantToSharePost(postId: Int32, postTitle: String) {
    NotificationCenter.default.post(
      name: .postShareFromPostOptionActionSheet,
      object: nil,
      userInfo: ["postId": postId,
                 "postTitle": postTitle])
  }
}
