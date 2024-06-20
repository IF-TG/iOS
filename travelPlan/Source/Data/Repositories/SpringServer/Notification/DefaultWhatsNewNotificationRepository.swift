//
//  DefaultNotificationRepository.swift
//  travelPlan
//
//  Created by 양승현 on 10/30/23.
//

import Combine

final class DefaultWhatsNewNotificationRepository {
  // MARK: - Properties
  private let service: Sessionable
  
  private var subscription: AnyCancellable?
  
  // MARK: - Lifecycle
  init(service: Sessionable) {
    self.service = service
  }
}

// MARK: - WhatsNewNotificationRepository
extension DefaultWhatsNewNotificationRepository: WhatsNewNotificationRepository {
  func fetchNotices() -> AnyPublisher<[NoticeEntity], any Error> {
    let noticeEndpoint = NotificationAPIEndpoints.fetchNotices()
    return Future { [weak self] promise in
      self?.subscription = self?.service
        .request(endpoint: noticeEndpoint)
        .sink { completion in
          switch completion {
          case .finished:
            return
          case .failure(let error):
            promise(.failure(error))
          }
        } receiveValue: { responseDTO in
          promise(.success(responseDTO.map { $0.toDomain }))
        }
    }.eraseToAnyPublisher()
  }
}
