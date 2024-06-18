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
  static let fetchedPostDetailForUniversalLink = Notification.Name("fetchedPostDetailForUniversalLink")
}

final class PostNotificationManager {
  static let shared = PostNotificationManager()
  
  private init() { }
}

// MARK: - For post option
extension PostNotificationManager {
  func notifyPostHasBlocked(postId: Int64, postOptionLocation: PostOptionLocation) {
    NotificationCenter.default.post(
      name: .hasPostBlocked,
      object: nil,
      userInfo: ["postId": postId,
                 "postOptionLocation": postOptionLocation])
  }
  
  func notifyUserWantToSharePost(postId: Int64, postTitle: String) {
    NotificationCenter.default.post(
      name: .postShareFromPostOptionActionSheet,
      object: nil,
      userInfo: ["postId": postId,
                 "postTitle": postTitle])
  }
  
  /// universal link에 의해 특정 포스트로 바로 들어와질 경우, PostDetailVM에서만 데이터를 fetch해서 소유하게 됩니다.
  /// 이때 PostDetailChatVM, PostOptionVM에게도 알려주어야 합니다.
  func notifyPostDetailFetchForAccessingUniversalLink(post: Post, completion: @escaping (Bool)->Void) {
    
    let fetchedPostDetailForUniversalLinkEntity = FetchedPostDetailForUniversalLinkEntity(
      postId: post.detail.postID,
      postTitle: post.detail.title,
      authorId: post.author.authorId,
      postAuthorNickname: post.author.nickname)
    guard let fetchedPostDetailData = try? JSONEncoder().encode(fetchedPostDetailForUniversalLinkEntity) else {
      completion(false)
      return
    }
    
    NotificationCenter.default.post(
      name: .fetchedPostDetailForUniversalLink,
      object: nil,
      userInfo: ["fetchedPostDetailForUniversalLink": fetchedPostDetailData])
  }
}
