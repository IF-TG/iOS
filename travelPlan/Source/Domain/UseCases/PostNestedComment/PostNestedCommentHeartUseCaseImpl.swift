//
//  PostNestedCommentHeartUseCaseImpl.swift
//  travelPlan
//
//  Created by 양승현 on 5/13/24.
//

import Foundation
import Combine

final class PostNestedCommentHeartUseCaseImpl {
  // MARK: - Dependencies
  private let nestedCommentHeartRepository: PostNestedCommentHeartRepository
  
  private let ownerRepository: LoggedInUserRepository
  
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable>()
  
  // MARK: - Lifecycle
  init(
    nestedCommentHeartRepository: PostNestedCommentHeartRepository,
    ownerRepository: LoggedInUserRepository
  ) {
    self.nestedCommentHeartRepository = nestedCommentHeartRepository
    self.ownerRepository = ownerRepository
  }
}

// MARK: - PostNestedCommentHeartUseCase
extension PostNestedCommentHeartUseCaseImpl: PostNestedCommentHeartUseCase {
  func toggleNestedCommentHeart(
    postId: String,
    commentId: String,
    nestedCommentId: String
  ) -> AnyPublisher<ToggledPostCommentHeartEntity, any Error> {
    return Future { [weak self] promise in
      guard let ownerId = self?.ownerRepository.id else {
        promise(.failure(LoggedInUserRepositoryError.invalidUserId))
        return
      }
      
      guard let self else {
        promise(.failure(ReferenceError.invalidReference))
        return
      }
      
      let subscription = nestedCommentHeartRepository
        .fetchNestedCommentHeartUsers(
          with: postId, commentId: commentId, nestedCommentId: nestedCommentId)
        .flatMap { [weak self] heartUsers in
          guard let self else {
            return Fail<ToggledPostCommentHeartEntity, Error>(error: ReferenceError.invalidReference)
              .eraseToAnyPublisher()
          }
          
          let willHeart = !heartUsers.contains(where: { $0 == ownerId })
          var heartTaskPublisher: AnyPublisher<Void, Error>
          if willHeart {
            heartTaskPublisher = nestedCommentHeartRepository.heartNestedComment(
              with: postId, commentId: commentId, nestedCommentId: nestedCommentId, userId: ownerId)
          } else {
            heartTaskPublisher = nestedCommentHeartRepository.hateNestedComment(
              with: postId, commentId: commentId, nestedCommentId: nestedCommentId, userId: ownerId)
          }
          return Publishers
            .Zip(
              heartTaskPublisher,
              nestedCommentHeartRepository.updateNestedCommentHearts(
                with: postId, commentId: commentId, nestedCommentId: nestedCommentId, willHeartComment: willHeart)
            ).map { _ in
              return ToggledPostCommentHeartEntity(id: nestedCommentId, isOnHeart: willHeart)
            }.eraseToAnyPublisher()
        }.sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { entity in
          promise(.success(entity))
        }
      subscriptions.insert(subscription)
    }.eraseToAnyPublisher()
  }
}
