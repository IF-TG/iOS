//
//  NotificationRepository.swift
//  travelPlan
//
//  Created by 양승현 on 10/30/23.
//

import Foundation

protocol NotificationRepository {
  func fetchNotices() -> [NoticeEntity]
}
