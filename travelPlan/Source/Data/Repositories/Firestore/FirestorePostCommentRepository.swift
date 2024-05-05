//
//  FirestorePostCommentRepository.swift
//  travelPlan
//
//  Created by 양승현 on 5/4/24.
//

import Combine
import Foundation
import FirebaseFirestore
import SHFirestoreService

@frozen enum FirestorePostCommentRepostioryError: LocalizedError {
  case invalidParameter
  case invalidSelfReference
  case invalidRequestTypeForQuery
  
  var errorDescription: String? {
    switch self {
    case .invalidParameter:
      return "Invalid function's input parameter"
    case .invalidSelfReference:
      return "Invalid self reference"
    case .invalidRequestTypeForQuery:
      return "Invalid request type for query"
    }
  }
}

final class FirestorePostCommentRepository {
  typealias Endpoint = FirestorePostCommentAPIEndpoint
  
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

// MARK: - PostAtomicCommentRepository
extension FirestorePostCommentRepository: PostAtomicCommentRepository {
  func sendComment(
    ownerId: String,
    postId: String,
    comment: String
  ) -> AnyPublisher<PostAtomicCommentEntity, any Error> {
    let commentId = UUID().uuidString
    
    let requestDTO = FirestorePostCommentSendRequestDTO(
      commentId: commentId,
      authorId: ownerId,
      createAt: Timestamp(date: Date()),
      comment: comment,
      hasDeleted: false,
      heartNum: 0)
    let endpoint = Endpoint.makeCommentSendEndpoint(postId: postId, commentId: commentId, with: requestDTO)
    
    return Future { [weak self, backgroundQueue] promise in
      // FIXME: - 저장할 경우 backgroundTask로 추가해야합니다.
      guard let self else {
        promise(.failure(ReferenceError.invalidReference))
        return
      }
      
      let requestSubscription = service.saveDocument(endpoint: endpoint)
        .subscribe(on: backgroundQueue)
        .receive(on: backgroundQueue)
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { _ in
          let postAtomicCommentEntity = PostAtomicCommentEntity(
            commentId: commentId,
            authorId: ownerId,
            comment: comment,
            createAt: requestDTO.createAt.dateValue(),
            hasDeleted: false,
            hearts: 0)
          promise(.success(postAtomicCommentEntity))

        }
      subscriptions.insert(requestSubscription)
    }.eraseToAnyPublisher()
  }
 
  func updateComment(
    postId: String,
    commentId: String,
    comment: String
  ) -> AnyPublisher<Void, any Error> {
    let requestDTO = PostCommentUpdateRequestDTO(commentId: commentId, comment: comment)
    let endpoint = Endpoint.makeCommentUpdateEndpoint(postId: postId, with: requestDTO)
    
    return Future { [weak self] promise in
      guard let self else {
        promise(.failure(FirestorePostCommentRepostioryError.invalidSelfReference))
        return
      }
      
      // FIXME: -  backgroundTask 도 추가해야합니다.
      let requestSubscription = self.service
        .request(endpoint: endpoint)
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { _ in
          promise(.success(()))
        }
      subscriptions.insert(requestSubscription)
    }.eraseToAnyPublisher()
  }
  
  func deleteComment(
    hasAnyNestedCommentExisted: Bool,
    postId: String,
    commentId: String
  ) -> AnyPublisher<Void, any Error> {
    // FIXME: - backgroundTask 추가해야합니다.
    let endpoint = switch hasAnyNestedCommentExisted {
    case true:
      Endpoint.makeCommentDeleteWhenNestedCommentExistEndpoint(postId: postId, commentId: commentId)
    case false:
      Endpoint.makeCommentDeleteEndpoint(postId: postId, commentId: commentId)
    }
    return Future { [weak self, backgroundQueue] promise in
      let requestSubscription = self?.service.request(endpoint: endpoint)
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
  
  func fetchComments(
    postId: String
  ) -> AnyPublisher<[PostAtomicCommentEntity], any Error> {
    let endpoint = Endpoint.makeCommentsFetchEndpoint(postId: postId)
    return Future { [weak self, backgroundQueue] promise in
      let querySubscription = self?.service.query(
        endpoint: endpoint, makeQuery: { reference in
          guard let reference = reference as? CollectionReference else {
            throw FirestorePostCommentRepostioryError.invalidRequestTypeForQuery
          }
          return reference.order(by: "createAt", descending: true)
        })
        .subscribe(on: backgroundQueue)
        .receive(on: backgroundQueue)
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { responseDTOs in
          promise(.success(responseDTOs.map { $0.toDomain() }))
        }
      self?.subscriptions.insert(querySubscription)
    }.eraseToAnyPublisher()
  }
}
