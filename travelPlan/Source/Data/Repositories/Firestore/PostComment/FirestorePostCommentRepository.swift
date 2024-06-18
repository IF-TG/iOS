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

// MARK: - PostAtomicCommentRepository
extension FirestorePostCommentRepository: PostAtomicCommentRepository {
  func sendComment(
    ownerId: UserIdentifier,
    postId: PostIdentifier,
    comment: String
  ) -> AnyPublisher<PostAtomicCommentEntity, any Error> {
    // 현재 Firestore가 아닌 Spring server을 사용하기로 번복했기에, -1을 넣습니다.
    // let commentId = UUID().uuidString
    
    let requestDTO = FirestorePostCommentSendRequestDTO(
      commentId: -1,
      authorId: ownerId,
      createAt: Timestamp(date: Date()),
      comment: comment,
      hasDeleted: false,
      heartNum: 0)
    let endpoint = Endpoint.makeCommentSendEndpoint(postId: postId, commentId: -1, with: requestDTO)
    
    return Future { [weak self, backgroundQueue] promise in
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
            commentId: -1, authorId: ownerId,
            comment: comment, createAt: requestDTO.createAt.dateValue(),
            hasDeleted: false, hearts: 0)
          promise(.success(postAtomicCommentEntity))
        }
      subscriptions.insert(requestSubscription)
    }.eraseToAnyPublisher()
  }
 
  func updateComment(
    postId: PostIdentifier,
    commentId: CommentIdentifier,
    comment: String
  ) -> AnyPublisher<Void, any Error> {
    let requestDTO = PostCommentUpdateRequestDTO(commentId: commentId, comment: comment)
    let endpoint = Endpoint.makeCommentUpdateEndpoint(postId: postId, with: requestDTO)
    
    return Future { [weak self] promise in
      guard let self else {
        promise(.failure(FirestorePostCommentRepostioryError.invalidSelfReference))
        return
      }
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
    postId: PostIdentifier,
    commentId: CommentIdentifier
  ) -> AnyPublisher<Void, any Error> {
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
    postId: PostIdentifier
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
