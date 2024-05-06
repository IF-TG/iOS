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
  /// 댓글 좋아요한 사용자 컬랙션에 좋아요한 사용자 리스트를 받아옵니다.
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
  
  /// 댓글 좋아요한 사용자 컬랙션에 좋아요한 사용자들 number를 받아옵니다.
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
  
  /// 댓글 좋아요한 사용자 컬랙션에 사용자를 추가합니다.
  func heartComment(
    with postId: String,
    commentId: String,
    userId: String
  ) -> AnyPublisher<Void, any Error> {
    let endpoint = Endpoint.makeCommentHeartEndpoint(with: postId, commentId: commentId, userId: userId)
    return Future { [weak self, backgroundQueue] promise in
      // TODO: - 이전 PR 머지되면 BackgroundTask로 백그라운드 전환해도 동작되도록 기능 추가해야합니다.
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
  
  /// 댓글 좋아요한 사용자 컬랙션에 사용자를 제거합니다.
  func hateComment(
    with postId: String,
    commentId: String,
    userId: String
  ) -> AnyPublisher<Void, any Error> {
    let endpoint = Endpoint.makeCommentHateEndpoint(with: postId, commentId: commentId, userId: userId)
    return Future { [weak self, backgroundQueue] promise in
      // TODO: - 이전 PR 머지되면 BackgroundTask로 백그라운드 전환해도 동작되도록 기능 추가해야합니다.
      let deleteSubscription = self?.service
        .request(endpoint: endpoint)
        .subscribe(on: backgroundQueue)
        .receive(on: backgroundQueue)
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { _ in
          promise(.success(()))
        }
      self?.subscriptions.insert(deleteSubscription)
    }.eraseToAnyPublisher()
  }
  
  /// 트렌젝션을 통해 댓글 좋아요한 사용자에 추가하고, 댓글 필드에 heartNum을 증가 또는 감소 시킵니다.
  func togglePostHearts(
    with postId: String,
    commentId: String,
    userId: String,
    willHeartComment: Bool
  ) -> AnyPublisher<Void, any Error> {
    let endpoint = Endpoint.makePostHeartsToggleEndpoint(with: postId, commentId: commentId)
    return Future { [weak self, backgroundQueue] promise in
      // TODO: - 이전 PR 머지되면 BackgroundTask로 백그라운드 전환해도 동작되도록 기능 추가해야합니다.
      let subscription = self?.service
        .performTransaction { transaction in
          guard let docRef = endpoint.requestType.documentRef else {
            return promise(.failure(FirestoreServiceError.documentNotFound))
          }
          let documentSnapshot = try transaction.getDocument(docRef)
          guard let commentHearts = documentSnapshot.data()?["heartNum"] as? Int else {
            let error = NSError(
              domain: "AppErrorDimain",
              code: -1,
              userInfo: [
                NSLocalizedDescriptionKey: "Unable to retrieve heartNum from snapshot \(documentSnapshot)"])
            throw error
          }
          transaction.updateData(
            ["heartNum": commentHearts + (willHeartComment ? 1 : -1)],
            forDocument: docRef)
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
      self?.subscriptions.insert(subscription)
    }.eraseToAnyPublisher()
  }
}
