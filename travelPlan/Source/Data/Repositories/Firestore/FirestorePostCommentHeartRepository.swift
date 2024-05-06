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
  
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable?>()
  
  // MARK: - Lifecycle
  init(
    service: FirestoreServiceProtocol
  ) {
    self.service = service
  }
}

// MARK: - PostCommentHeartRepository
extension FirestorePostCommentHeartRepository: PostCommentHeartRepository {
  func fetchCommentHeartUsers(
    _ postId: String,
    _ commentId: String
  ) -> AnyPublisher<[UserIdentifier], any Error> {
    let endpoint = Endpoint.makeCommentHeartUsersFetchEndpoint(postId, commentId)
    return Future { [weak self] promise in
      let retrieveSubscription = self?.service
        .retrieveDocumentIDs(endpoint: endpoint)
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
    _ postId: String,
    _ commentId: String
  ) -> AnyPublisher<Int, any Error> {
    fatalError("미구현")
  }
  
  func heartComment(
    _ postId: String,
    commentId: String,
    userId: String
  ) -> AnyPublisher<Void, any Error> {
    fatalError("미구현")
  }
  
  func hateComment(
    _ postId: String,
    commentId: String,
    userId: String
  ) -> AnyPublisher<Void, any Error> {
    fatalError("미구현")
  }
  
  func togglePostHearts(
    _ postId: String,
    commentId: String,
    userId: String,
    willHeartComment: Bool
  ) -> AnyPublisher<Void, any Error> {
    fatalError("미구현")
  }
}
