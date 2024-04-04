//
//  DefaultUserBlockRepository.swift
//  travelPlan
//
//  Created by 양승현 on 4/1/24.
//

import Foundation
import Combine

final class DefaultUserBlockRepository: UserBlockRepository {
  typealias endpoint = UserBlockAPIEndpoint
  
  // MARK: - Dependencies
  private let service: Sessionable
  private let backgroundQueue: DispatchQueue
  
  // MARK: - Properites
  private var subscriptions = Set<AnyCancellable>()
  
  // MARK: - Lifecycle
  init(service: Sessionable, backgroundQueue: DispatchQueue = DispatchQueue.global(qos: .background)) {
    self.service = service
    self.backgroundQueue = backgroundQueue
  }
  
  func blockUser(with userId: Int64) -> AnyPublisher<BlockedUserIdentifyEntity, any Error> {
    let requestDTO = UserBlockRequestDTO(blockedUserId: userId)
    return Future { [weak self] promise in
      guard let self else {
        promise(.failure(ReferenceError.invalidReference))
        return
      }
      service.request(endpoint: endpoint.blockUser(with: requestDTO))
        .subscribe(on: backgroundQueue)
        .mapConnectionError()
        .map { $0.result }
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { result in
          promise(.success(result.toDomain()))
        }.store(in: &subscriptions)
    }.eraseToAnyPublisher()
  }
  
  func fetchBlockedUsers() -> AnyPublisher<[BlockedUserProfileEntity], any Error> {
    return Future { [weak self] promise in
      guard let self else {
        promise(.failure(ReferenceError.invalidReference))
        return
      }
      service.request(endpoint: endpoint.fetchBlockedUsers())
        .subscribe(on: backgroundQueue)
        .mapConnectionError()
        .map { $0.result }
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { result in
          promise(.success(result.map { $0.toDomain() }))
        }.store(in: &subscriptions)
    }.eraseToAnyPublisher()
  }
}
