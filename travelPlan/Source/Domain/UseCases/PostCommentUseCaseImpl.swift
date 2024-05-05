//
//  PostCommentUseCaseImpl.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/5/24.
//

import Foundation
import Combine

final class PostCommentUseCaseImpl {
  // MARK: - Dependencies
  private let postAtomicCommentRepository: PostAtomicCommentRepository
  private let ownerRepository: LoggedInUserRepository
  private let myProfileRepository: MyProfileRepository
  private let backgroundQueue: DispatchQueue
  
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable?>()
  
  // MARK: - Lifecycle
  init(
    ownerRepository: LoggedInUserRepository,
    postAtomicCommentRepository: PostAtomicCommentRepository,
    myProfileRepository: MyProfileRepository,
    backgroundQueue: DispatchQueue
  ) {
    self.ownerRepository = ownerRepository
    self.postAtomicCommentRepository = postAtomicCommentRepository
    self.myProfileRepository = myProfileRepository
    self.backgroundQueue = backgroundQueue
  }
}

extension PostCommentUseCaseImpl: PostCommentUseCase {
  func sendComment(
    postId: String,
    comment: String
  ) -> AnyPublisher<PostCommentEntity, any Error> {
    guard let ownerId = ownerRepository.id else {
      return Fail(error: LoggedInUserRepositoryError.invalidUserId).eraseToAnyPublisher()
    }
    
    return Future { [weak self] promise in
      let commentSendSubscription = self?.postAtomicCommentRepository
        .sendComment(ownerId: ownerId, postId: postId, comment: comment)
        .sink { completeion in
          if case .failure(let error) = completeion {
            promise(.failure(error))
          }
        } receiveValue: { atomicCommentEntity in
          var author: UserEntity?
          let group = DispatchGroup()
          if let owner = self?.ownerRepository.user {
            author = owner
            group.leave()
          } else {
            let ownerProfileSubscription = self?.myProfileRepository
              .fetchProfile(with: ownerId)
              .sink { completion in
                if case .failure(let error) = completion {
                  promise(.failure(error))
                }
              } receiveValue: { userEntity in
                self?.ownerRepository.setUser(with: userEntity)
                author = userEntity
                group.leave()
              }
            self?.subscriptions.insert(ownerProfileSubscription)
          }
          self?.handleCommentSend(
            author: author,
            atomicCommentEntity: atomicCommentEntity,
            with: group,
            promise: promise)
        }
      self?.subscriptions.insert(commentSendSubscription)
    }.eraseToAnyPublisher()
  }
  
  private func handleCommentSend(
    author: UserEntity?,
    atomicCommentEntity entity: PostAtomicCommentEntity,
    with group: DispatchGroup,
    promise: @escaping Future<PostCommentEntity, Error>.Promise
  ) {
    // FIXME: - TimestampConverter 사용해서 timeago로 변환해야합니다.
    group.notify(queue: backgroundQueue) {
      guard let author else { return }
      let commentEntity = PostCommentEntity(
        commentId: entity.commentId,
        userProfileImageData: author.profileImageData,
        userName: author.nickname,
        timestamp: String(entity.createAt.description),
        comment: entity.comment,
        isDeleted: false,
        isOnHeart: false,
        isBlocked: false,
        hearts: Int32(0),
        nestedComments: [])
      promise(.success(commentEntity))
    }
  }
  
  func updateComment(
    postId: String?,
    commentId: String, 
    comment: String
  ) -> AnyPublisher<Bool, any Error> {
    fatalError()
  }
  
  func deleteComment(
    postId: String?,
    commentId: String
  ) -> AnyPublisher<Bool, any Error> {
    fatalError()
  }
  
  func fetchComments(
    with requestValue: PostCommentsRequestValue
  ) -> AnyPublisher<[PostCommentEntity], any Error> {
    fatalError()
  }
  
  func toggleCommentHeart(
    postId: String?,
    commentId: String
  ) -> AnyPublisher<ToggledPostCommentHeartEntity, any Error> {
    fatalError()
  }
}
