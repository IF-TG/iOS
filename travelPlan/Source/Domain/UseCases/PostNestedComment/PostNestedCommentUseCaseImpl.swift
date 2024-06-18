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
  case timeoutGroupTask
  case invalidReference
}

final class PostNestedCommentUseCaseImpl {
  // MARK: - Dependencies
  private let nestedCommentRepository: PostAtomicNestedCommentRepository
  
  private let commentRepository: PostAtomicCommentRepository
  
  private let ownerRepository: LoggedInUserRepository
  
  private let backgroundQueue: DispatchQueue
  
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable?>()
  
  // MARK: - Lifecycle
  init(
    nestedCommentRepository: PostAtomicNestedCommentRepository,
    ownerRepository: LoggedInUserRepository,
    commentRepository: PostAtomicCommentRepository,
    backgroundQueue: DispatchQueue = DispatchQueue(
      label: "PostNestedCommentUseCase", qos: .default, attributes: .concurrent)
  ) {
    self.nestedCommentRepository = nestedCommentRepository
    self.ownerRepository = ownerRepository
    self.commentRepository = commentRepository
    self.backgroundQueue = backgroundQueue
  }
}

extension PostNestedCommentUseCaseImpl: PostNestedCommentUseCase {
  func sendNestedComment(
    postId: PostIdentifier,
    commentId: CommentIdentifier,
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
          authorId: ownerId,
          userProfileImageData: owner.profileImageData,
          nickname: owner.nickname,
          timestamp: DateTimeConverter.timeAgo(from: postAtomicNestedCommentEntity.createAt),
          comment: comment,
          hearts: 0,
          isOnHeart: false)
      }.eraseToAnyPublisher()
  }
  
  func updateNestedComment(
    postId: PostIdentifier,
    commentId: CommentIdentifier,
    nestedCommentId: NestedCommentIdentifier,
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
  
  /// 대댓글 삭제
  ///
  /// Notes:
  /// - 대댓글이 전부 제거된 로직 수행후 댓글도 삭제된 것이라면, 여기서 해당 댓글도 삭제합니다.
  /// - 사용측에선 대댓 개수 확인하고 해당 댓글도 제거하는 ui 반영해야 합니다.
  func deleteNestedComment(
    postId: PostIdentifier,
    commentId: CommentIdentifier,
    nestedCommentId: NestedCommentIdentifier,
    hasDeletedComment: Bool
  ) -> AnyPublisher<DeletedNestedCommentResult, any Error> {
    return nestedCommentRepository
        .deleteNestedComment(
          postId: postId, commentId: commentId, nestedCommentId: nestedCommentId)
        .receive(on: backgroundQueue)
        .flatMap { [weak self] _ -> AnyPublisher<DeletedNestedCommentResult, any Error>  in
          guard let self else {
            return Fail(error: PostNestedCommentUseCaseImplError.invalidReference).eraseToAnyPublisher()
          }
          
          /// 대댓 개수 가져오기.
          return nestedCommentRepository
            .fetchTheNumberOfNestedComments(postId: postId, commentId: commentId)
            .flatMap { [weak self] numberOfNestedComments -> AnyPublisher<DeletedNestedCommentResult, any Error> in
              guard let self else {
                return Fail(error: PostNestedCommentUseCaseImplError.invalidReference).eraseToAnyPublisher()
              }
              
              let hasAnyNestedCommentExisted = numberOfNestedComments > 0
              
              guard hasDeletedComment else {
                return justANestedCommentDeletedPublihser
              }
              
              if hasAnyNestedCommentExisted {
                return justANestedCommentDeletedPublihser
              }
              
              /// 삭제한 대댓글이 마지막 대댓글인 경우
              return commentRepository
                .deleteComment(
                  hasAnyNestedCommentExisted: hasAnyNestedCommentExisted,
                  postId: postId,
                  commentId: commentId)
                .map { _ in return .ACommentAndAllNestedCommentsDeleted }
                .eraseToAnyPublisher()
            }.eraseToAnyPublisher()
        }.eraseToAnyPublisher()
  }
  
  private var justANestedCommentDeletedPublihser: AnyPublisher<DeletedNestedCommentResult, any Error> {
    return Just(.justANestedCommentDeleted)
      .setFailureType(to: Error.self)
      .eraseToAnyPublisher()
  }
}
