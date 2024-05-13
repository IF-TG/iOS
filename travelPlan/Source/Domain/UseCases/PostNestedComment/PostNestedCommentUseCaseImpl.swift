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
    return Future { [weak self, backgroundQueue] promise in
      let deleteNestedComment = self?.nestedCommentRepository
        .deleteNestedComment(
          postId: postId, commentId: commentId, nestedCommentId: nestedCommentId)
        .receive(on: backgroundQueue)
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { [weak self] _ in
          guard let self else {
            promise(.failure(ReferenceError.invalidReference))
            return
          }
          var hasAnyNestedCommentExisted: Bool = true
          let group = DispatchGroup()
          /// 어차피 대댓은 삭제된거.
          
          group.enter()
          /// 대댓 개수 가져오기.
          let nestedCommentsFetcher = nestedCommentRepository
            .fetchTheNumberOfNestedComments(postId: postId, commentId: commentId)
            .sink { completion in
              if case .failure(let error) = completion {
                promise(.failure(error))
              }
            } receiveValue: { nestedComments in
              hasAnyNestedCommentExisted = nestedComments > 0
              group.leave()
            }
          subscriptions.insert(nestedCommentsFetcher)
          // TODO: 이게 계속 정지 동작되는지 테스트해야함.
          if group.wait(timeout: .now() + 30) == .timedOut {
            promise(.failure(PostNestedCommentUseCaseImplError.timeoutGroupTask))
            return
          }
          // 대댓글 개수가 0개라면
          // 아래 로직으로 댓글 삭제해주세요.
          // 그리고 이 레포가 커서 얘만 따로 분리할 필요도 있다.
          guard hasDeletedComment else {
            promise(.success(true))
            return
          }
          if hasAnyNestedCommentExisted {
            promise(.success(true))
            return
          }
          
          /// 삭제한 대댓글이 마지막 대댓글인 경우
          let commentDeletePublihser = commentRepository
            .deleteComment(
              hasAnyNestedCommentExisted: hasAnyNestedCommentExisted,
              postId: postId,
              commentId: commentId)
            .sink { completion in
              if case .failure(let error) = completion {
                promise(.failure(error))
              }
            } receiveValue: { _ in
              promise(.success(true))
            }
          subscriptions.insert(commentDeletePublihser)
        }
      self?.subscriptions.insert(deleteNestedComment)
    }.eraseToAnyPublisher()
  }
}
