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
  private let whatsNewNotificationRepository: WhatsNewNotificationRepository
  
  // MARK: - Properties
  var whatsNewNoticeEntities: CurrentValueSubject<[NoticeEntity], any Error> = .init([])
  
  private var subscriptions = Set<AnyCancellable>()
  
  // MARK: - Lifecycle
  init(whatsNewNotificationRepository: WhatsNewNotificationRepository) {
    self.whatsNewNotificationRepository = whatsNewNotificationRepository
  }
  
  func fetchWhatsNewNotices() {
    whatsNewNotificationRepository
      .fetchNotices()
      .sink(receiveCompletion: { [weak self] completion in
        if case .failure(let error) = completion {
          self?.whatsNewNoticeEntities.send(completion: .failure(error))
        }
      }, receiveValue: { [weak self] noticeEntities in
        self?.whatsNewNoticeEntities.send(noticeEntities)
      }).store(in: &subscriptions)
  }
}
