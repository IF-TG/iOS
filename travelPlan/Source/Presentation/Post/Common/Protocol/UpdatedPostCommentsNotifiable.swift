//
//  UpdatedPostCommentsNotifiable.swift
//  travelPlan
//
//  Created by 양승현 on 6/21/24.
//

import Combine
import Foundation

protocol UpdatedPostCommentsNotifiable {
  var updatedPostCommentsNotifier: PassthroughSubject<UpdatedPostCommentsEntity, Never> { get }
  
  func makeUpdatedPostCommentsNotificationSubscriber() -> AnyCancellable
}

extension UpdatedPostCommentsNotifiable where Self: AnyObject {
  func makeUpdatedPostCommentsNotificationSubscriber() -> AnyCancellable {
    return NotificationCenter
      .default
      .publisher(for: .updatedPostComments)
      .sink { [weak self] notification in
        if let userInfo = notification.userInfo,
           let postId = userInfo["postId"] as? Int64,
           let postComments = userInfo["postComments"] as? Int32,
           let hasEnteredByDeferredDeepLink = userInfo["hasEnteredByDeferredDeepLink"] as? Bool {
          let entity = UpdatedPostCommentsEntity(
            postId: postId,
            postComments: postComments,
            hasEnteredByDeferredDeepLink: hasEnteredByDeferredDeepLink)
          self?.updatedPostCommentsNotifier.send(entity)
        }
      }
  }
}
