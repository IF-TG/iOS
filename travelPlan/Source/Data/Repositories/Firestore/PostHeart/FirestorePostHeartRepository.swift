//
//  FirestorePostHeartRepository.swift
//  travelPlan
//
//  Created by 양승현 on 5/1/24.
//

import Foundation
import SHFirestoreService
import Combine
import FirebaseFirestore

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

// MARK: - PostHeartRepository
extension FirestorePostHeartRepository: PostHeartRepository {
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
  
  func hatePost(
    _ postId: String,
    userId: String
  ) -> AnyPublisher<Void, any Error> {
    let endpoint = Endpoint.makeHatePostEndpoint(postId: postId, userId: userId)
    return Future { [weak self, backgroundQueue] promise in
      let requestSubscription = self?.service
        .request(endpoint: endpoint)
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
  
  /// Posts collection에서 a specific document의 heartNum 필드 값을 transaction을 활용해 증가, 감소 시킵니다.
  func updatePostHearts(
    _ postId: String,
    willHeartPost: Bool
  ) -> AnyPublisher<Void, any Error> {
    let endpoint = Endpoint.makeTogglePostHeartsEndpoint(postId: postId)
    return Future { [weak self, backgroundQueue] promise in
      let requestSubscription = self?.service
        .performTransaction { transaction in
          guard let documentRef = endpoint.requestType.documentRef else {
            return promise(.failure(FirestoreServiceError.documentNotFound))
          }
          do {
            let documentSnapshot = try transaction.getDocument(documentRef)
            
            guard let prevPostHearts = documentSnapshot.data()?["heartNum"] as? Int else {
              let error = NSError(
                domain: "AppErrorDimain",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Unable to retrieve heartNum from snapshot \(documentSnapshot)"])
              promise(.failure(FirestoreServiceError.failedTransaction(error)))
              return nil
            }
            transaction.updateData(["heartNum": prevPostHearts + (willHeartPost ? 1 : -1)], forDocument: documentRef)
          } catch {
            promise(.failure(FirestoreServiceError.failedTransaction(error)))
          }
          return nil
        }
        .subscribe(on: backgroundQueue)
        .receive(on: backgroundQueue)
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
  
  func fetchPostHearts(
    _ postId: String
  ) -> AnyPublisher<Int, any Error> {
    let endpoint = Endpoint.makeFetchPostHeartsEndpoint(postId)
    return Future { [weak self, backgroundQueue] promise in
      let requestSubscription = self?.service
        .request(endpoint: endpoint)
        .subscribe(on: backgroundQueue)
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { responseDTO in
          promise(.success(responseDTO.postHearts))
        }
      self?.subscriptions.insert(requestSubscription)
    }.eraseToAnyPublisher()
  }
}
