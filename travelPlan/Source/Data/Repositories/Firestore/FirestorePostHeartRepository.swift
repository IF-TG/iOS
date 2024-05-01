//
//  FirestorePostHeartRepository.swift
//  travelPlan
//
//  Created by 양승현 on 5/1/24.
//

import Foundation
import SHFirestoreService
import Combine

final class FirestorePostHeartRepository {
  typealias Endpoint = FirestorePostHeartAPIEndpoint
  
  // MARK: - Dependencies
  private let service: FirestoreServiceProtocol
  private let backgroundQueue: DispatchQueue
  
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable?>()
  
  // MARK: - Lifecycle
  init(
    service: FirestoreServiceProtocol,
    backgroundQueue: DispatchQueue = .global(qos: .userInitiated)
  ) {
    self.service = service
    self.backgroundQueue = backgroundQueue
  }
}

extension FirestorePostHeartRepository: PostHeartRepository {
  func fetchHeartUsers(
    _ postId: String
  ) -> AnyPublisher<[String], any Error> {
    let endpoint = Endpoint.makeFetchHeartUsersEndpoint(postId)
    return Future { [weak self, backgroundQueue] promise in
      let requestSubscription = self?.service
        .retrieveDocumentIDs(endpoint: endpoint)
        .subscribe(on: backgroundQueue)
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { userIDs in
          promise(.success(userIDs))
        }
      self?.subscriptions.insert(requestSubscription)
    }.eraseToAnyPublisher()
  }
  
  func heartPost(
    _ postId: String,
    userId: String
  ) -> AnyPublisher<Void, any Error> {
    let endpoint = Endpoint.makeHeartPostEndpoint(postId: postId, userId: userId)
    return Future { [weak self, backgroundQueue] promise in
      let requestSubscription = self?.service
        .saveDocument(endpoint: endpoint)
        .subscribe(on: backgroundQueue)
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { _ in
          promise(.success(()))
        }
      self?.subscriptions.insert(requestSubscription)
    }.eraseToAnyPublisher()
  }
  
  func hatePost(_ postId: String, userId: String) -> AnyPublisher<Void, any Error> {
    fatalError("아직 미 구현")
  }
}
