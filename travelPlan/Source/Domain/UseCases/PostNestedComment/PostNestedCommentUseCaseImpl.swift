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
  // 사용측에선 대댓 개수 확인하고 해당 댓글도 제거하는 ui 반영해야핢
  // 반환타입을 두개로 해야함. 대댓, 댓 전부 삭제인지, 대댓만 삭제인지 enum으로 하자.
  func deleteNestedComment(
    postId: String,
    commentId: String,
    nestedCommentId: String,
    hasDeletedComment: Bool
  ) -> AnyPublisher<Bool, any Error> {
    return nestedCommentRepository
        .deleteNestedComment(
          postId: postId, commentId: commentId, nestedCommentId: nestedCommentId)
        .receive(on: backgroundQueue)
        .flatMap { [weak self] _ in
          guard let self else {
            return Fail<Bool, any Error>(error: ReferenceError.invalidReference)
              .mapError { $0 as Error }
              .eraseToAnyPublisher()
          }
          
          /// 대댓 개수 가져오기.
          return nestedCommentRepository
            .fetchTheNumberOfNestedComments(postId: postId, commentId: commentId)
            .flatMap { numberOfNestedComments in
              var hasAnyNestedCommentExisted = numberOfNestedComments > 0
              guard hasDeletedComment else {
                return Just(true).setFailureType(to: Error.self).eraseToAnyPublisher()
              }
              if hasAnyNestedCommentExisted {
                return Just(true).setFailureType(to: Error.self).eraseToAnyPublisher()
              }
              
              /// 삭제한 대댓글이 마지막 대댓글인 경우
              return self.commentRepository
                .deleteComment(
                  hasAnyNestedCommentExisted: hasAnyNestedCommentExisted,
                  postId: postId,
                  commentId: commentId)
              /// d이거 enum으로 하자 댓, 대댓ㄱ 전부 삭제
                .map { _ in return true }
                .eraseToAnyPublisher()
            }.eraseToAnyPublisher()
        }.eraseToAnyPublisher()
  }
}
