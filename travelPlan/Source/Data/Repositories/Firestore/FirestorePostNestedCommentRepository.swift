//
//  FirestorePostNestedCommentRepository.swift
//  travelPlan
//
//  Created by 양승현 on 5/7/24.
//

import Combine
import Foundation
import FirebaseFirestore
import SHFirestoreService

final class FirestorePostNestedCommentRepository {
  typealias Endpoint = FirestorePostNestedCommentAPIEndpoint
  
  // MARK: - Dependencies
  private let backgroundQueue: DispatchQueue
  private let service: FirestoreServiceProtocol
  
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

// MARK: - PostAtomicNestedCommentRepository
extension FirestorePostNestedCommentRepository: PostAtomicNestedCommentRepository {
  func fetchNestedComments(
    postId: String,
    commentId: String
  ) -> AnyPublisher<[PostAtomicNestedCommentEntity], any Error> {
    fatalError("아직 미구현입니다.")
  }
  
  func sendNestedComment(
    ownerId: String,
    postId: String,
    commentId: String,
    comment: String
  ) -> AnyPublisher<PostAtomicNestedCommentEntity, any Error> {
    let nestedCommentId = UUID().uuidString
    let requestDTO = FirestorePostNestedCommentSendRequestDTO(
      nestedCommentId: nestedCommentId, authorId: ownerId,
      comment: comment, hearts: 0, createAt: Timestamp(date: Date()))
    let endpoint = Endpoint.makeNestedCommentSendEndpoint(
      withPostId: postId, commentId: commentId, nestedCommentId: nestedCommentId, requestDTO: requestDTO)
    return Future { [weak self, backgroundQueue] promise in
      guard let self else {
        promise(.failure(ReferenceError.invalidReference))
        return
      }
      let saveSubscription = service.saveDocument(endpoint: endpoint)
        .subscribe(on: backgroundQueue)
        .receive(on: backgroundQueue)
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { _ in
          let atomicEntity = PostAtomicNestedCommentEntity(
            nestedCommentId: nestedCommentId, authorId: ownerId, comment: comment,
            createAt: requestDTO.createAt.dateValue(), hearts: 0)
          promise(.success(atomicEntity))
        }
      subscriptions.insert(saveSubscription)
    }.eraseToAnyPublisher()
  }
  
  func updateNestedComment(
    ownerId: String,
    postId: String,
    commentId: String
  ) -> AnyPublisher<Void, any Error> {
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
