//
//  NotificationViewAdapterDataSource.swift
//  travelPlan
//
//  Created by 양승현 on 11/2/23.
//

import Foundation

protocol NotificationViewAdapterDataSource {
  var numberOfItems: Int { get }
  func getItem(_ indexPath: IndexPath) -> NotificationInfo
}