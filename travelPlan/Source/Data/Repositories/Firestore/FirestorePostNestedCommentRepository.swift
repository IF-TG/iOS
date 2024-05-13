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
    let endpoint = Endpoint.makeNestedCommentsFetchEndpoint(withPostId: postId, commentId: commentId)
    return Future { [weak self, backgroundQueue] promise in
      let fetch = self?.service.request(endpoint: endpoint)
        .subscribe(on: backgroundQueue)
        .receive(on: backgroundQueue)
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { responseDTO in
          let entities = responseDTO.map { $0.toDomain() }
          promise(.success(entities))
        }
      self?.subscriptions.insert(fetch)
    }.eraseToAnyPublisher()
  }
  
  func fetchTheNumberOfNestedComments(
    postId: String,
    commentId: String
  ) -> AnyPublisher<Int, any Error> {
    let endpoint = Endpoint.makeTheNumberOfNestedCommentsFetchEndpoint(withPostId: postId, commentId: commentId)
    return Future { [weak self, backgroundQueue] promise in
      let fetch = self?.service.request(endpoint: endpoint)
        .subscribe(on: backgroundQueue)
        .receive(on: backgroundQueue)
        .sink(receiveCompletion: { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        }, receiveValue: { result in
          promise(.success(result))
        })
      self?.subscriptions.insert(fetch)
    }.eraseToAnyPublisher()
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
    postId: String,
    commentId: String,
    nestedCommentId: String,
    comment: String
  ) -> AnyPublisher<Void, any Error> {
    let requestDTO = PostNestedCommentUpdateRequestDTO(nestedCommentId: nestedCommentId, comment: comment)
    let endpoint = Endpoint.makeNestedCommentUpdateEndpoint(
      withPostId: postId, commentId: commentId, nestedCommentId: nestedCommentId, requestDTO: requestDTO)
    return Future { [weak self, backgroundQueue] promise in
      let request = self?.service.request(endpoint: endpoint)
        .subscribe(on: backgroundQueue)
        .receive(on: backgroundQueue)
        .sink(promise: promise)
      self?.subscriptions.insert(request)
    }.eraseToAnyPublisher()
  }
  
  func deleteNestedComment(
    postId: String,
    commentId: String,
    nestedCommentId: String,
    hasDeletedComment: Bool
  ) -> AnyPublisher<Void, any Error> {
    let endpoint = Endpoint.makeNestedCommentDeleteEndpoint(
      withPostId: postId, commentId: commentId, nestedCommentId: nestedCommentId)
    return Future { [weak self, backgroundQueue] promise in
      // TODO: - 댓글 제거되면 트랜젝션으로 댓, 대댓 다 제거하기
      let request = self?.service.request(endpoint: endpoint)
        .subscribe(on: backgroundQueue)
        .receive(on: backgroundQueue)
        .sink(promise: promise)
      self?.subscriptions.insert(request)
    }.eraseToAnyPublisher()
  }
  
  func deleteAllNestedComments(
    postId: String,
    commentId: String
  ) -> AnyPublisher<Void, any Error> {
    let endpoint = Endpoint.makeNestedCommentsAllDeleteEndpoint(withPostId: postId, commentId: commentId)
    return Future { [weak self, backgroundQueue] promise in
      let request = self?.service.request(endpoint: endpoint)
        .subscribe(on: backgroundQueue)
        .receive(on: backgroundQueue)
        .sink(promise: promise)
      self?.subscriptions.insert(request)
    }.eraseToAnyPublisher()
  }
}
