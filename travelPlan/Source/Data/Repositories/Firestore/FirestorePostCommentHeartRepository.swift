//
//  FirestorePostCommentHeartRepository.swift
//  travelPlan
//
//  Created by 양승현 on 5/6/24.
//

import Combine
import Foundation
import SHFirestoreService

final class FirestorePostCommentHeartRepository {
  typealias Endpoint = FirestorePostCommentHeartAPIEndopint
  
  // MARK: - Dependencies
  private let service: FirestoreServiceProtocol
  private let backgroundQueue: DispatchQueue
  
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable?>()
  
  // MARK: - Lifecycle
  init(
    service: FirestoreServiceProtocol,
    backgroundQueue: DispatchQueue = DispatchQueue(label: "PostCommentHeart", qos: .default, attributes: .concurrent)
  ) {
    self.service = service
    self.backgroundQueue = backgroundQueue
  }
}

// MARK: - PostCommentHeartRepository
extension FirestorePostCommentHeartRepository: PostCommentHeartRepository {
  func fetchCommentHeartUsers(
    with postId: String,
    commentId: String
  ) -> AnyPublisher<[UserIdentifier], any Error> {
    let endpoint = Endpoint.makeCommentHeartUsersFetchEndpoint(with: postId, commentId: commentId)
    return Future { [weak self, backgroundQueue] promise in
      let retrieveSubscription = self?.service
        .retrieveDocumentIDs(endpoint: endpoint)
        .subscribe(on: backgroundQueue)
        .receive(on: backgroundQueue)
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { commentHeartUsers in
          promise(.success(commentHeartUsers))
        }
      self?.subscriptions.insert(retrieveSubscription)
    }.eraseToAnyPublisher()
  }
  
  func fetchCommentHearts(
    with postId: String,
    commentId: String
  ) -> AnyPublisher<Int, any Error> {
    return Future { [weak self, backgroundQueue] promise in
      let commentHeartFetchSubscription = self?.fetchCommentHeartUsers(with: postId, commentId: commentId)
        .subscribe(on: backgroundQueue)
        .receive(on: backgroundQueue)
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { commentHeartUsers in
          promise(.success(commentHeartUsers.count))
        }
      self?.subscriptions.insert(commentHeartFetchSubscription)
    }.eraseToAnyPublisher()
  }
  
  func heartComment(
    with postId: String,
    commentId: String,
    userId: String
  ) -> AnyPublisher<Void, any Error> {
    let endpoint = Endpoint.makeCommentHeartEndpoint(with: postId, commentId: commentId, userId: userId)
    return Future { [weak self, backgroundQueue] promise in
      let saveSubscription = self?.service
        .saveDocument(endpoint: endpoint)
        .subscribe(on: backgroundQueue)
        .receive(on: backgroundQueue)
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { _ in
          promise(.success(()))
        }
      self?.subscriptions.insert(saveSubscription)
    }.eraseToAnyPublisher()
  }
  
  func hateComment(
    with postId: String,
    commentId: String,
    userId: String
  ) -> AnyPublisher<Void, any Error> {
    fatalError("미구현")
  }
  
  func togglePostHearts(
    with postId: String,
    commentId: String,
    userId: String,
    willHeartComment: Bool
  ) -> AnyPublisher<Void, any Error> {
    fatalError("미구현")
  }
}
