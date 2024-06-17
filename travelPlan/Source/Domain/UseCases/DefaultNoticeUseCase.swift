//
//  DefaultNoticeUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 10/30/23.
//

import Combine
import Foundation

final class DefaultNoticeUseCase: NoticeUseCase {
  // MARK: - Dependencies
  private let notificationRepository: WhatsNewNotificationRepository
  
  // MARK: - Properties
  var noticeEntities: CurrentValueSubject<[NoticeEntity], Never> = .init([])
  
  private var subscriptions = Set<AnyCancellable>()
  
  // MARK: - Lifecycle
  init(notificationRepository: WhatsNewNotificationRepository) {
    self.notificationRepository = notificationRepository
  }
  
  func fetchNotices() {
    notificationRepository
      .fetchNotices()
      .sink { [weak self] noticeEntities in
        self?.noticeEntities.send(noticeEntities)
      }.store(in: &subscriptions)
  }
}
