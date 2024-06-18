//
//  PostBlockedNotifiable.swift
//  travelPlan
//
//  Created by 양승현 on 6/9/24.
//

import Combine
import Foundation

/// 사용자가 포스트를 차단할 때 postHasBlockedNotifier를 통해 특정 postId를 수신받을 수 있습니다.
protocol PostBlockedNotifiable {
  typealias PostBlockedElement = (postId: PostIdentifier, postOptionLocation: PostOptionLocation)
  
  /// 옵셔널이 보내질 경우 notification.userInfo가 잘못된 경우 입니다.
  var postHasBlockedNotifier: PassthroughSubject<PostBlockedElement?, Never> { get }
  
  func makePostHasBlockedNotificationPublisher() -> AnyCancellable
}

extension PostBlockedNotifiable where Self: AnyObject {
  /// 포스트가 차단됬을때 notification을 받기 위해선 anyCancellable을 holding해야합니다.
  ///
  /// hasPostBlocked 이름으로 notification이 올 경우 보내는 측에서 이 구조를 변경하지 않는 이상 postHasBlockedNotifier가 nil을 전송하는 경우는 희박합니다.
  func makePostHasBlockedNotificationPublisher() -> AnyCancellable {
    return NotificationCenter.default
      .publisher(for: .hasPostBlocked)
      .sink { [weak self] notification in
        if let userInfo = notification.userInfo,
           let postId = userInfo["postId"] as? PostIdentifier,
           let postOptionLocation = userInfo["postOptionLocation"] as? PostOptionLocation {
          self?.postHasBlockedNotifier.send((postId, postOptionLocation))
          return
        }
        self?.postHasBlockedNotifier.send(nil)
      }
  }
}
