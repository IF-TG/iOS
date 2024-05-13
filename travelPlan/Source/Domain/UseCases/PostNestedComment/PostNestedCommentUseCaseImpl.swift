//
//  PostNestedCommentUseCaseImpl.swift
//  travelPlan
//
//  Created by 양승현 on 5/13/24.
//

import Foundation
import Combine

@frozen enum PostNestedCommentUseCaseImplError: Error {
  case invalidUserId
  case invalidOwnerEntity
}

final class PostNestedCommentUseCaseImpl {
  // MARK: - Dependencies
  private let nestedCommentRepository: PostAtomicNestedCommentRepository
  
  private let ownerRepository: LoggedInUserRepository
  
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable?>()
  
  // MARK: - Lifecycle
  init(
    nestedCommentRepository: PostAtomicNestedCommentRepository,
    ownerRepository: LoggedInUserRepository
  ) {
    self.nestedCommentRepository = nestedCommentRepository
    self.ownerRepository = ownerRepository
  }
}

extension PostNestedCommentUseCaseImpl: PostNestedCommentUseCase {
  func sendNestedComment(
    postId: String,
    commentId: String,
    comment: String
  ) -> AnyPublisher<PostNestedCommentEntity, any Error> {
    guard let ownerId = ownerRepository.id else {
      return Fail(error: PostNestedCommentUseCaseImplError.invalidUserId).eraseToAnyPublisher()
    }
    
    guard let owner = ownerRepository.user else {
      return Fail(error: PostNestedCommentUseCaseImplError.invalidOwnerEntity).eraseToAnyPublisher()
    }
    return nestedCommentRepository
      .sendNestedComment(
        ownerId: ownerId, postId: postId, commentId: commentId, comment: comment)
      .map { postAtomicNestedCommentEntity in
        return PostNestedCommentEntity(
          nestedCommentId: postAtomicNestedCommentEntity.nestedCommentId,
          userProfileImageData: owner.profileImageData,
          nickname: owner.nickname,
          timestamp: DateTimeConverter.timeAgo(from: postAtomicNestedCommentEntity.createAt),
          comment: comment,
          hearts: 0,
          isOnHeart: false)
      }.eraseToAnyPublisher()
  }
  
  func updateNestedComment(
    postId: String,
    commentId: String,
    nestedCommentId: String,
    comment: String
  ) -> AnyPublisher<Bool, any Error> {
    return nestedCommentRepository
      .updateNestedComment(
        postId: postId,
        commentId: commentId,
        nestedCommentId: nestedCommentId,
        comment: comment)
      .map { _ in return true }
      .eraseToAnyPublisher()
  }
  
  // TODO: 대댓글이 전부 제거되었을때, 댓글도 삭제된 것이라면, 여기서 댓글도 삭제하자.
  func deleteNestedComment(
    postId: String,
    commentId: String,
    nestedCommentId: String,
    hasDeletedComment: Bool
  ) -> AnyPublisher<Bool, any Error> {
    return nestedCommentRepository
      .deleteNestedComment(
        postId: postId, commentId: commentId, nestedCommentId: nestedCommentId)
      .map { _ in return true }
      .eraseToAnyPublisher()
  }
}
