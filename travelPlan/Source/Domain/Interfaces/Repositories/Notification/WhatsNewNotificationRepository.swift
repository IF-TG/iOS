//
//  WhatsNewNotificationRepository.swift
//  travelPlan
//
//  Created by 양승현 on 10/30/23.
//

import Combine

protocol WhatsNewNotificationRepository {
  func fetchNotices() -> AnyPublisher<[NoticeEntity], any Error>
}
