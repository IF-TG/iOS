//
//  PostOptionNotificationBinder.swift
//  travelPlan
//
//  Created by 양승현 on 6/15/24.
//

import Combine
import Foundation

protocol PostOptionNotificationBinder: AnyObject, PostBlockedNotifiable, UserWantToSharePostNotifiable {
  var postOptionNotificationSubscriptions: Set<AnyCancellable> { get set }
}

extension PostOptionNotificationBinder {
  /// 포스트 옵션 버튼을 누른 결과로 NotificationCenter에서 post한 포스트 차단 및 포스트 공유로직을 받을 수 있는 함수입니다.
  ///
  /// Parameters:
  /// - Parameter postBlockHandler: 사용자가 포스트 옵션 버튼을 누른 후 포스트 차단을 누른 경우 postBlockHandler가 호출됩니다.
  /// - Parameter postShareHandler: 사용자가 포스트 옵션 버튼을 누른 후 공유하기를 누른 경우 postShareHandler가 호출됩니다.
  func bindPostOptionResult(
    postBlockHandler: @escaping (PostBlockedElement?) -> Void,
    postShareHandler: @escaping ((postId: Int32, postTitle: String)) -> Void
  ) {
    makePostHasBlockedNotificationPublisher()
      .store(in: &postOptionNotificationSubscriptions)
    postHasBlockedNotifier
      .receive(on: DispatchQueue.main)
      .sink { element in
        postBlockHandler(element)
      }.store(in: &postOptionNotificationSubscriptions)
    
    makeUserWantToSharePostNotificationPublisher()
      .store(in: &postOptionNotificationSubscriptions)
    userWantToSharePostNotifier
      .receive(on: DispatchQueue.main)
      .sink { element in
        postShareHandler(element)
      }.store(in: &postOptionNotificationSubscriptions)
  }
}
