//
//  UserWantToSharePostNotifiable.swift
//  travelPlan
//
//  Created by 양승현 on 6/15/24.
//

import Foundation
import Combine

protocol UserWantToSharePostNotifiable {
  typealias PostId = Int32
  
  var userWantToSharePostNotifier: PassthroughSubject<PostId, Never> { get }
  
  func makeUserWantToSharePostNotificationPublisher() -> AnyCancellable
}

extension UserWantToSharePostNotifiable where Self: AnyObject {
  func makeUserWantToSharePostNotificationPublisher() -> AnyCancellable {
    return NotificationCenter
      .default
      .publisher(for: .postShareFromPostOptionActionSheet)
      .sink { [weak self] notification in
        if let userInfo = notification.userInfo,
           let postId = userInfo["postId"] as? Int32 {
          self?.userWantToSharePostNotifier.send(postId)
        }
      }
  }
}
