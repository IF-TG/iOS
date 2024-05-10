//
//  FirestorePostNestedCommentHeartRepository.swift
//  travelPlan
//
//  Created by 양승현 on 5/10/24.
//

import Combine
import Foundation
import SHFirestoreService

final class FirestorePostNestedCommentHeartRepository {
  typealias Endpoint = FirestoreNestedCommentHeartAPIEndpoints
  
  // MARK: - Dependencies
  private let service: FirestoreServiceProtocol
  private let backgroundQueue: DispatchQueue
  
  // MARK: - Properties
  private var subscriptions: Set<AnyCancellable?>
  
  // MARK: - Lifecycle
  init(
    service: FirestoreServiceProtocol,
    backgroundQueue: DispatchQueue = DispatchQueue(
      label: "PostNestedCommentHeart", qos: .default, attributes: .concurrent)
  ) {
    self.service = service
    self.backgroundQueue = backgroundQueue
    subscriptions = .init()
  }
}

extension FirestorePostNestedCommentHeartRepository: PostNestedCommentHeartRepository {
  func fetchNestedCommentHeartUsers(
    with postId: String,
    commentId: String
  ) -> AnyPublisher<[UserIdentifier], any Error> {
    fatalError("미구현")
  }
  
  func fetchNestedCommentHearts(
    with postId: String,
    commentId: String
  ) -> AnyPublisher<Int, any Error> {
    fatalError("미구현")
  }
  
  func heartNestedComment(
    with postId: String,
    commentId: String,
    userId: String
  ) -> AnyPublisher<Void, any Error> {
    fatalError("미구현")
  }
  
  func hateNestedComment(
    with postId: String,
    commentId: String,
    userId: String
  ) -> AnyPublisher<Void, any Error> {
    fatalError("미구현")
  }
  
  func updateNestedCommentHearts(
    with postId: String,
    commentId: String,
    userId: String, 
    willHeartComment: Bool
  ) -> AnyPublisher<Void, any Error> {
    fatalError("미구현")
  }
}
