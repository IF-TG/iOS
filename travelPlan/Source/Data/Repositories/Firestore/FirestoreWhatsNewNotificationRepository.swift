//
//  FirestoreWhatsNewNotificationRepository.swift
//  travelPlan
//
//  Created by 양승현 on 6/17/24.
//

import Combine
import Foundation
import SHFirestoreService

final class FirestoreWhatsNewNotificationRepository {
  typealias Endpoint = FirestoreWhatsNewNotificaitonEndpoint
  
  // MARK: - Properties
  private let service: FirestoreServiceProtocol
  
  private var subscription: AnyCancellable?
  
  // MARK: - Lifecycle
  init(service: FirestoreServiceProtocol) {
    self.service = service
  }
}

extension FirestoreWhatsNewNotificationRepository: WhatsNewNotificationRepository {
  func fetchNotices() -> AnyPublisher<[NoticeEntity], any Error> {
    return Future<[NoticeEntity], any Error> { [weak self] promise in
      let endpoint = Endpoint.makeWhatsNewNotificationFetchkEndpoint()
      
      self?.subscription = self?.service
        .request(endpoint: endpoint)
        .receive(on: DispatchQueue.global())
        .sink(receiveCompletion: { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        }, receiveValue: { responseDTOs in
          promise(.success(responseDTOs.map { $0.toDomain() }))
        })
    }.eraseToAnyPublisher()
  }
}
