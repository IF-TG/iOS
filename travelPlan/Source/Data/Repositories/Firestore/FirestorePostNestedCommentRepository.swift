//
//  FirestorePostNestedCommentRepository.swift
//  travelPlan
//
//  Created by 양승현 on 5/7/24.
//

import Combine
import Foundation
import SHFirestoreService

final class FirestorePostNestedCommentRepository {
  typealias Endpoint = FirestorePostNestedCommentAPIEndpoint
  
  // MARK: - Dependencies
  private let backgroundQueue: DispatchQueue
  private let service: FirestoreServiceProtocol
  private let firebaseStorageService: ImageStorageServiceProtocol
  
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable?>()
  
  // MARK: - Lifecycle
  init(
    service: FirestoreServiceProtocol,
    backgroundQueue: DispatchQueue = .global(qos: .userInitiated),
    firebaseStorageService: ImageStorageServiceProtocol
  ) {
    self.service = service
    self.backgroundQueue = backgroundQueue
    self.firebaseStorageService = firebaseStorageService
  }
}

// MARK: - PostAtomicNestedCommentRepository
extension FirestorePostNestedCommentRepository: PostAtomicNestedCommentRepository {
  func fetchNestedComments(
    postId: String,
    commentId: String
  ) -> AnyPublisher<[PostAtomicNestedCommentEntity], any Error> {
    
  }
  
  func sendNestedComment(
    ownerId: String,
    postId: String,
    commentId: String
  ) -> AnyPublisher<[PostAtomicNestedCommentEntity], any Error> {
    fatalError("아직 미구현입니다.")
  }
  
  func updateNestedComment(
    ownerId: String,
    postId: String,
    commentId: String
  ) -> AnyPublisher<[PostAtomicNestedCommentEntity], any Error> {
    fatalError("아직 미구현입니다.")
  }
  
  func deleteNestedComment(
    hasCommentDeleted: Bool,
    postId: String,
    commentId: String,
    nestedCommentId: String
  ) -> AnyPublisher<Void, any Error> {
    fatalError("아직 미구현입니다.")
  }
}
