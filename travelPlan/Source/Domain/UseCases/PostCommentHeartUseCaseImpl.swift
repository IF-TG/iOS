//
//  PostCommentHeartUseCaseImpl.swift
//  travelPlan
//
//  Created by 양승현 on 5/6/24.
//

import Foundation
import Combine

final class PostCommentHeartUseCaseImpl {
  // MARK: - Dependencies
  private let commentHeartRepository: PostCommentHeartRepository
  private let ownerRepository: LoggedInUserRepository
  private let backgroundQueue: DispatchQueue
  
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable?>()
  
  // MARK: - Lifecycle
  init(
    commentHeartRepository: PostCommentHeartRepository,
    ownerRepository: LoggedInUserRepository,
    backgroundQueue: DispatchQueue = .init(
      label: "PostCommentHeartUseCase",
      qos: .default,
      attributes: .concurrent)
  ) {
    self.commentHeartRepository = commentHeartRepository
    self.ownerRepository = ownerRepository
    self.backgroundQueue = backgroundQueue
  }
}

// MARK: - PostCommentHeartUseCase
extension PostCommentHeartUseCaseImpl: PostCommentHeartUseCase {
  func toggleCommentHeart(
    postId: String,
    commentId: String
  ) -> AnyPublisher<ToggledPostCommentHeartEntity, any Error> {
    // TODO: - 여기서 백그라운드 추가해야합니다.
    return Future { [weak self, backgroundQueue] promise in
      guard let ownerId = self?.ownerRepository.id else {
        promise(.failure(LoggedInUserRepositoryError.invalidUserId))
        return
      }
      var commentHeartUsers: [String] = []
      let initialTask = DispatchGroup()
      let group = DispatchGroup()
      
      initialTask.enter()
      let commentHeartUsersFetchSubscription = self?.commentHeartRepository
        .fetchCommentHeartUsers(with: postId, commentId: commentId)
        .subscribe(on: backgroundQueue)
        .receive(on: backgroundQueue)
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { users in
          commentHeartUsers = users
          initialTask.leave()
        }
      self?.subscriptions.insert(commentHeartUsersFetchSubscription)
      
      if initialTask.wait(timeout: .now() + .seconds(15)) == .timedOut {
        let timeoutErr = NSError(
          domain: "PostCommentHeartUseCase",
          code: 0,
          userInfo: [NSLocalizedDescriptionKey: "Fetching comment heart users operation timed out"])
        promise(.failure(timeoutErr))
      }
            
      let willHeartComment = !commentHeartUsers.contains(where: { $0 == ownerId })
      group.enter()
      switch willHeartComment {
      case true:
        let commentHeartSubscription = self?.commentHeartRepository
          .heartComment(with: postId, commentId: commentId, userId: ownerId)
          .subscribe(on: backgroundQueue)
          .receive(on: backgroundQueue)
          .sink(receiveCompletion: { completion in
            if case .failure(let error) = completion {
              promise(.failure(error))
            }
          }, receiveValue: { _ in
            group.leave()
          })
        self?.subscriptions.insert(commentHeartSubscription)
      case false:
        let commentHateSubscription = self?.commentHeartRepository
          .hateComment(with: postId, commentId: commentId, userId: ownerId)
          .subscribe(on: backgroundQueue)
          .receive(on: backgroundQueue)
          .sink(receiveCompletion: { completion in
            if case .failure(let error) = completion {
              promise(.failure(error))
            }
          }, receiveValue: { _ in
            group.leave()
          })
        self?.subscriptions.insert(commentHateSubscription)
      }
      
      group.enter()
      let commentHeartUpdateSubscription = self?.commentHeartRepository
        .updateCommentHearts(
          with: postId, commentId: commentId, userId: ownerId, willHeartComment: willHeartComment)
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { _ in
          group.leave()
        }
      self?.subscriptions.insert(commentHeartUpdateSubscription)
      group.notify(queue: backgroundQueue) {
        promise(.success(.init(id: commentId, isOnHeart: willHeartComment)))
      }
    }.eraseToAnyPublisher()
  }
}
