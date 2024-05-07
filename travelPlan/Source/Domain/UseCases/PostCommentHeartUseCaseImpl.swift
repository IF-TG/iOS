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
    return Future { [weak self, backgroundQueue] promise in
      guard let ownerId = self?.ownerRepository.id else {
        promise(.failure(LoggedInUserRepositoryError.invalidUserId))
        return
      }
      guard let self else {
        promise(.failure(ReferenceError.invalidReference))
        return
      }
 
      let subscription = commentHeartRepository
        .fetchCommentHeartUsers(with: postId, commentId: commentId)
        .subscribe(on: backgroundQueue)
        .receive(on: backgroundQueue)
        .flatMap { [weak self] commentHeartUsers in
          guard let self else {
            return Fail<ToggledPostCommentHeartEntity, ReferenceError>(error: ReferenceError.invalidReference)
              .mapError { $0 as Error }
              .eraseToAnyPublisher()
          }
          let willHeartComment = !commentHeartUsers.contains(where: { $0 == ownerId })
          var heartPublisher: AnyPublisher<Void, Error>
          if willHeartComment {
            heartPublisher = commentHeartRepository
              .heartComment(with: postId, commentId: commentId, userId: ownerId)
          } else {
            heartPublisher = commentHeartRepository
              .hateComment(with: postId, commentId: commentId, userId: ownerId)
          }
          return Publishers
            .Zip(
              heartPublisher,
              commentHeartRepository.updateCommentHearts(
                with: postId, commentId: commentId, userId: ownerId, willHeartComment: willHeartComment))
            .receive(on: backgroundQueue)
            .map { _ in
              return ToggledPostCommentHeartEntity(id: commentId, isOnHeart: willHeartComment)
            }
            .eraseToAnyPublisher()
        }
        .sink { completion in
          if case .failure(let error) = completion { promise(.failure(error)) }
        } receiveValue: { entity in
          promise(.success(entity))
        }
      subscriptions.insert(subscription)
    }.eraseToAnyPublisher()
  }
}
