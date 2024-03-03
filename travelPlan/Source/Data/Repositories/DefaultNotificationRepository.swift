//
//  DefaultNotificationRepository.swift
//  travelPlan
//
//  Created by 양승현 on 10/30/23.
//

import Combine

final class DefaultNotificationRepository {
  // MARK: - Properties
  private let service: Sessionable
  
  private var subscription: AnyCancellable?
  
  // MARK: - Lifecycle
  init(service: Sessionable) {
    self.service = service
  }
}

// MARK: - NotificationRepository
extension DefaultNotificationRepository: NotificationRepository {
  func fetchNotices() -> Future<[NoticeEntity], Never> {
    let noticeEndpoint = NotificationAPIEndpoints.fetchNotices()
    return .init { [weak self] promise in
      self?.subscription = self?.service
        .request(endpoint: noticeEndpoint)
        .sink { completion in
          switch completion {
          case .finished:
            return
          case .failure(let error):
            print("DEBUG: \(error.localizedDescription)")
          }
        } receiveValue: { responseDTO in
          promise(.success(responseDTO.map { $0.toDomain }))
        }
    }
  }
}
