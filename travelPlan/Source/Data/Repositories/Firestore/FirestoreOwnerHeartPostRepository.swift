//
//  FirestoreOwnerHeartPostRepository.swift
//  travelPlan
//
//  Created by 양승현 on 5/16/24.
//

import Combine
import Foundation
import SHFirestoreService

final class FirestoreOwnerHeartPostRepository {
  typealias Endpoint = FirestorePostHeartAPIEndpoint
  
  // MARK: - Dependencies
  private let ownerStorage: OwnerStorage
  
  private let service: FirestoreServiceProtocol
  
  private let backgroundQueue: DispatchQueue
  
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable?>()
  
  // MARK: - Lifecycle
  init(
    ownerStorage: OwnerStorage,
    service: FirestoreServiceProtocol,
    backgroundQueue: DispatchQueue = DispatchQueue(
      label: "FirestoreOwnerRepository.com", qos: .userInitiated, attributes: .concurrent)
  ) {
    self.ownerStorage = ownerStorage
    self.service = service
    self.backgroundQueue = backgroundQueue
  }
}

// MARK: - OwnerHeartPostRepository
extension FirestoreOwnerHeartPostRepository: OwnerHeartPostRepository {
  func fetchOwnerHeartPostIdentifiers() -> AnyPublisher<[PostIdentifier], any Error> {
    /// 로그인한 사용자는 반드시 있어야하는 정보입니다.
    guard let ownerId = ownerStorage.id else {
      return Fail(error: ReferenceError.invalidReference).mapError { $0 as Error }.eraseToAnyPublisher()
    }
    
    let endpoint = Endpoint.makeOwnerHeartPostIdentifiersFetchEndpoint(userId: ownerId)
    return Future { [weak self, backgroundQueue] promise in
      let request = self?.service
        .retrieveDocumentIDs(endpoint: endpoint)
        .receive(on: backgroundQueue)
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { postIdentifiers in
          promise(.success(postIdentifiers))
        }
      self?.subscriptions.insert(request)
    }.eraseToAnyPublisher()
  }
  
  func hasOwnerHeartPost(
    postId: PostIdentifier
  ) -> AnyPublisher<Bool, any Error> {
    /// 로그인한 사용자는 반드시 있어야하는 정보입니다.
    guard let ownerId = ownerStorage.id else {
      return Fail(error: ReferenceError.invalidReference).mapError { $0 as Error }.eraseToAnyPublisher()
    }
    
    let endpoint = Endpoint.makeOwnerHasHeartSpecificPostEndpoint(postId: postId, userId: ownerId)
    return service
      .isDocumentExists(endpoint: endpoint)
      .mapError { $0 as Error }
      .eraseToAnyPublisher()
  }
}
