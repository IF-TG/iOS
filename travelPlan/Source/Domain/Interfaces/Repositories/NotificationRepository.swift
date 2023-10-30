//
//  NotificationRepository.swift
//  travelPlan
//
//  Created by 양승현 on 10/30/23.
//

import Combine

protocol NotificationRepository {
  func fetchNotices() -> Future<[NoticeEntity], Never>
}
