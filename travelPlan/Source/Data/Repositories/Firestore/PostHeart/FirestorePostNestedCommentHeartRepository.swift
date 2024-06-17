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
    with postId: PostIdentifier,
    commentId: CommentIdentifier,
    nestedCommentId: NestedCommentIdentifier
  ) -> AnyPublisher<[UserIdentifier], any Error> {
    let endpoint = Endpoint.makeNestedCommentHeartUsersFetchEndpoint(
      withPostId: postId,
      commentId: commentId,
      nestedCommentId: nestedCommentId)
    return Future { [weak self, backgroundQueue] promise in
      let fetch = self?.service
        .retrieveDocumentIDs(endpoint: endpoint)
        .subscribeAndReceive(on: backgroundQueue)
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { responseDTO in
          // Spring Server를 사용해 Firestore를 사용하지 않지만, Firestore를 사용해야한다면 타입은 String이 되야 합니다.
          promise(.success(responseDTO.map {UserIdentifier($0) ?? -1}))
        }
      self?.subscriptions.insert(fetch)
    }.eraseToAnyPublisher()
  }
  
  func fetchNestedCommentHearts(
    with postId: PostIdentifier,
    commentId: CommentIdentifier,
    nestedCommentId: NestedCommentIdentifier
  ) -> AnyPublisher<Int, any Error> {
    let endpoint = Endpoint.makeNestedCommentHeartsFetchEndpoint(
      withPostId: postId, commentId: commentId, nestedCommentId: nestedCommentId)
    return Future { [weak self, backgroundQueue] promise in
      let fetch = self?.service
        .request(endpoint: endpoint)
        .subscribeAndReceive(on: backgroundQueue)
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { responseDTO in
          promise(.success(responseDTO.heartNum))
        }
      self?.subscriptions.insert(fetch)
    }.eraseToAnyPublisher()
  }
  
  func heartNestedComment(
    with postId: PostIdentifier,
    commentId: CommentIdentifier,
    nestedCommentId: NestedCommentIdentifier,
    userId: UserIdentifier
  ) -> AnyPublisher<Void, any Error> {
    let endpoint = Endpoint.makeNestedCommentHeartEndpoint(
      withPostId: postId,
      commentId: commentId,
      nestedCommentId: nestedCommentId, userId: userId)
    return Future { [weak self, backgroundQueue] promise in
      let heart = self?.service
        .saveDocument(endpoint: endpoint)
        .subscribeAndReceive(on: backgroundQueue)
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { _ in
          promise(.success(()))
        }
      self?.subscriptions.insert(heart)
    }.eraseToAnyPublisher()
  }
  
  func hateNestedComment(
    with postId: PostIdentifier,
    commentId: CommentIdentifier,
    nestedCommentId: NestedCommentIdentifier,
    userId: UserIdentifier
  ) -> AnyPublisher<Void, any Error> {
    let endpoint = Endpoint.makeNestedCommentHateEndpoint(
      withPostId: postId, commentId: commentId, nestedCommentId: nestedCommentId, userId: userId)
    return Future { [weak self, backgroundQueue] promise in
      let hate = self?.service
        .request(endpoint: endpoint)
        .subscribeAndReceive(on: backgroundQueue)
        .sink(promise: promise)
      self?.subscriptions.insert(hate)
    }.eraseToAnyPublisher()
  }
  
  func updateNestedCommentHearts(
    with postId: PostIdentifier,
    commentId: CommentIdentifier,
    nestedCommentId: NestedCommentIdentifier,
    willHeartComment: Bool
  ) -> AnyPublisher<Void, any Error> {
    let endpoint = Endpoint.makeNestedCommentHeartsUpdateEndpoint(
      withPostId: postId, commentId: commentId, nestedCommentId: nestedCommentId)
    return Future { [weak self, backgroundQueue] promise in
      let transaction = self?.service
        .performTransaction { transaction in
          guard let docRef = endpoint.requestType.documentRef else {
            return promise(.failure(FirestoreServiceError.documentNotFound))
          }
          let snapshot = try transaction.getDocument(docRef)
          guard let nestedCommentHearts = snapshot.data()?["heartNum"] as? Int else {
            let error = NSError(
              domain: "AppErrorDimain",
              code: -1,
              userInfo: [
                NSLocalizedDescriptionKey: "Unable to retrieve heartNum from snapshot \(snapshot)"])
            throw error
          }
          transaction.updateData(
            ["heartNum": nestedCommentHearts + (willHeartComment ? 1 : -1)],
            forDocument: docRef)
          return nil
        }.subscribeAndReceive(on: backgroundQueue)
        .map { _ in return () }
        .sink(promise: promise)
      self?.subscriptions.insert(transaction)
    }.eraseToAnyPublisher()
  }
}
