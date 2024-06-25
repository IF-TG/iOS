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
  static let updatedPostComments = Notification.Name("updatedPostComments")
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
  func notifyPostDetailFetchForAccessingUniversalLink(post: Post, completion: @escaping (Bool) -> Void) {
    
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
  
  /// 포스트 상세 화면에서 댓글, 대댓글이 삭제되거나 추가될 경우에 호출되는 notifiaction입니다.
  /// 포스트 상세 화면에서 댓글, 대댓글 삭제 or 추가지 때 포스트 상세화면에서 보여지는 댓글 총 개수가 반영되야 합니다.
  /// 피드 화면 -> 피드 상세 화면으로 이동한 경우, 다시 뒤로 갈 때 피드 화면에서도 댓글 총 개수가 반영되야 합니다.
  ///   차단하기에 의해 댓글 화면에서 사라진 경우 포스트 총 개수에 변화는 반영하지 않습니다.
  func notifyUpdatedPostComments(
    postId: PostIdentifier,
    numberOfPostComments: Int32,
    hasEnteredByDeferredDeepLink: Bool
  ) {
    NotificationCenter.default.post(
      name: .updatedPostComments,
      object: nil,
      userInfo: ["postId": postId,
                 "postComments": numberOfPostComments,
                 "hasEnteredByDeferredDeepLink": hasEnteredByDeferredDeepLink])
  }
}
