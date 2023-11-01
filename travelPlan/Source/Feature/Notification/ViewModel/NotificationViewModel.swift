//
//  NotificationViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 11/2/23.
//

import Foundation

final class NotificationViewModel {
  let notifications = NotificationInfo.mockData() 
}

// MARK: - NotificationViewAdapterDataSource
extension NotificationViewModel: NotificationViewAdapterDataSource {
  var numberOfItems: Int {
    notifications.count
  }
  
  func getItem(_ indexPath: IndexPath) -> NotificationInfo {
    notifications[indexPath.row]
  }
}
