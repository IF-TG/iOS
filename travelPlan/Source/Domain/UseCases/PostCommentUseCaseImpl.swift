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
  private let userProfileRepository: UserProfileRepository
  private let backgroundQueue: DispatchQueue
  
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable?>()
  
  // MARK: - Lifecycle
  init(
    ownerRepository: LoggedInUserRepository,
    postAtomicCommentRepository: PostAtomicCommentRepository,
    userProfileRepository: UserProfileRepository,
    backgroundQueue: DispatchQueue
  ) {
    self.ownerRepository = ownerRepository
    self.postAtomicCommentRepository = postAtomicCommentRepository
    self.userProfileRepository = userProfileRepository
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
            let ownerProfileSubscription = self?.userProfileRepository
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
    postId: String,
    commentId: String,
    comment: String
  ) -> AnyPublisher<Bool, any Error> {
    return postAtomicCommentRepository
      .updateComment(postId: postId, commentId: commentId, comment: comment)
      .map { true }
      .eraseToAnyPublisher()
  }
  
  func deleteComment(
    postId: String,
    commentId: String
  ) -> AnyPublisher<Bool, any Error> {
    return postAtomicCommentRepository
      .deleteComment(
        // FIXME: - NestedComment가 있는지 가져와야 합니다.
        hasAnyNestedCommentExisted: false,
        postId: postId,
        commentId: commentId)
      .map { true }
      .eraseToAnyPublisher()
  }
  
  func fetchComments(
    with requestValue: PostCommentsRequestValue
  ) -> AnyPublisher<[PostCommentEntity], any Error> {
    return Future { [weak self, backgroundQueue] promise in
      let commentsFetchSubscription = self?.postAtomicCommentRepository
        .fetchComments(postId: requestValue.postId)
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { atomicCommentEntities in
          let groupManager = DispatchGroup()
          var postComments: [(index: Int, entity: PostCommentEntity)] = []
          atomicCommentEntities.enumerated().forEach { i, atomicCommentEntity in
            groupManager.enter()
            let group = DispatchGroup()
            var commentAuthor: UserEntity?
            var hasBlocked: Bool = false
            var isOnHeart: Bool = false
            var nestedComments: [PostNestedCommentEntity] = []
            group.enter()
            let profileFetchSubscription = self?.userProfileRepository
              .fetchProfile(with: atomicCommentEntity.authorId)
              .sink { completion in
                if case .failure(let error) = completion {
                  // TODO: - 로그를 남겨보자,,
                  print("DEBUG  사용자 정보 받아오는 도중 에러가 발생했습니다.", error.localizedDescription, atomicCommentEntity)
                  group.leave()
                }
              } receiveValue: { author in
                commentAuthor = author
                group.leave()
              }
            self?.subscriptions.insert(profileFetchSubscription)
            
            // MARK: - NestedComments받아와야 합니다: ]
            fatalError("NestedComments 받아와야 합니다.")
            
            // MARK: - PostCommentHeartRepository에서 하트 했는지 받아와야합니다.
            fatalError("PostCOmmentHeartRepository에서 하트 했는지 받아와야 합니다.")
            
            hasBlocked = self?.ownerRepository.hasBlockedUser(with: atomicCommentEntity.authorId) ?? false
            group.notify(queue: backgroundQueue) { [weak self, i] in
              if let commentAuthor, let self {
                let postComment = makePostCommentEntity(
                  atomicCommentEntity: atomicCommentEntity,
                  commentAuthor: commentAuthor,
                  isOnHeart: isOnHeart,
                  isBlocked: hasBlocked,
                  nestedComments: nestedComments)
                postComments.append((i, postComment))
              }
              groupManager.leave()
            }
          }
        }
      self?.subscriptions.insert(commentsFetchSubscription)
    }.eraseToAnyPublisher()
  }
  
  private func makePostCommentEntity(
    atomicCommentEntity: PostAtomicCommentEntity,
    commentAuthor: UserEntity,
    isOnHeart: Bool,
    isBlocked: Bool,
    nestedComments: [PostNestedCommentEntity]
  ) -> PostCommentEntity {
    // TODO: - Timestamp timeago로 구현해야합니다.
    return PostCommentEntity(
      commentId: atomicCommentEntity.commentId,
      userName: commentAuthor.nickname,
      timestamp: atomicCommentEntity.createAt.description, 
      comment: atomicCommentEntity.comment,
      isDeleted: atomicCommentEntity.hasDeleted,
      isOnHeart: isOnHeart,
      isBlocked: isBlocked,
      hearts: Int32(atomicCommentEntity.hearts),
      nestedComments: nestedComments)
  }
  
  func toggleCommentHeart(
    postId: String,
    commentId: String
  ) -> AnyPublisher<ToggledPostCommentHeartEntity, any Error> {
    fatalError()
  }
}
