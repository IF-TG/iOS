//
//  PostCommentUseCaseImpl.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/5/24.
//

import Foundation
import Combine
import os.log

final class PostCommentUseCaseImpl {
  // MARK: - Dependencies
  private let postAtomicCommentRepository: PostAtomicCommentRepository
  private let postNestedCommentRepository: PostAtomicNestedCommentRepository
  private let ownerRepository: LoggedInUserRepository
  private let userProfileRepository: UserProfileRepository
  private let postNestedCommentHeartRepository: PostNestedCommentHeartRepository
  private let postCommentHeartRepository: PostCommentHeartRepository
  private let backgroundQueue: DispatchQueue
  
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable?>()
  
  // MARK: - Lifecycle
  init(
    ownerRepository: LoggedInUserRepository,
    postAtomicCommentRepository: PostAtomicCommentRepository,
    postNestedCommentRepository: PostAtomicNestedCommentRepository,
    userProfileRepository: UserProfileRepository,
    postNestedCommentHeartRepository: PostNestedCommentHeartRepository,
    postCommentHeartRepository: PostCommentHeartRepository,
    backgroundQueue: DispatchQueue
  ) {
    self.ownerRepository = ownerRepository
    self.postAtomicCommentRepository = postAtomicCommentRepository
    self.userProfileRepository = userProfileRepository
    self.postNestedCommentRepository = postNestedCommentRepository
    self.postCommentHeartRepository = postCommentHeartRepository
    self.postNestedCommentHeartRepository = postNestedCommentHeartRepository
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
    group.notify(queue: backgroundQueue) {
      guard let author else { return }
      let commentEntity = PostCommentEntity(
        commentId: entity.commentId,
        userProfileImageData: author.profileImageData,
        userName: author.nickname,
        timestamp: DateTimeConverter.timeAgo(from: entity.createAt),
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
    return postNestedCommentRepository.fetchTheNumberOfNestedComments(postId: postId, commentId: commentId)
      .flatMap { [weak self] numberOfNestedComments in
        guard let self else {
          return Fail<Bool, ReferenceError>(error: ReferenceError.invalidReference)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
        }
        return postAtomicCommentRepository
          .deleteComment(
            hasAnyNestedCommentExisted: numberOfNestedComments > 0,
            postId: postId,
            commentId: commentId)
          .map { true }
          .eraseToAnyPublisher()
      }.eraseToAnyPublisher()
  }
  
  typealias IndexedNestedComment = (indexForSorting: Int, nestedCommentEntity: PostNestedCommentEntity)
  
  func fetchComments(
    with requestValue: PostCommentsRequestValue
  ) -> AnyPublisher<[PostCommentEntity], any Error> {
    let postId = requestValue.postId
    return Future { [weak self] promise in
      let fetchComments = self?.postAtomicCommentRepository.fetchComments(postId: postId)
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { [weak self] atomicCommentEntities in
          guard let self else {
            promise(.failure(ReferenceError.invalidReference))
            return
          }
          
          /// cf. 로그인을 한 유저라면 ownerId가 반드시 userDefaults에 저장되어 있긴 합니다.
          guard let ownerId = ownerRepository.id else {
            promise(.failure(LoggedInUserRepositoryError.invalidUserId))
            return
          }
          let postCommentsGroupManager = DispatchGroup()
          var postComments: [(index: Int, entity: PostCommentEntity?)] = []
          
          for (i, atomicCommentEntity) in atomicCommentEntities.enumerated() {
            postCommentsGroupManager.enter()
            let atomicToNestedCommentGroup = DispatchGroup(), commentId = atomicCommentEntity.commentId
            var commentAuthor: UserEntity?, hasBlocked: Bool?, isOnHeart: Bool?
            var nestedComments: [PostNestedCommentEntity] = []
            // TODO: - 각각의 publihser마다 발생가능한에러 PostUseCaseImplErr로 묶자.
            
            atomicToNestedCommentGroup.enter()
            let fetchNestedCommentAuthorProfile = Publishers.Zip(
              fetchUserProfileEntity(with: atomicCommentEntity.authorId),
              fetchCommentHeartUsers(postId: postId, commentId: commentId))
              .sink { completion in
                if case .failure(let error) = completion {
                  // TODO: - 로그에 기록. 특정 대댓글 authorId로 해당 사용자 프로필 받아올때 왜 에러를 갖는지, 형식이 잘못됬는지 등 분석..
                  print(error)
                  atomicToNestedCommentGroup.leave()
                }
              } receiveValue: { commentAuthorEntity, commentHeartUsers in
                commentAuthor = commentAuthorEntity
                isOnHeart = commentHeartUsers.contains { $0 == ownerId }
              }
            subscriptions.insert(fetchNestedCommentAuthorProfile)
            
            atomicToNestedCommentGroup.enter()
            let fetchNestedComments = fetchIndexedNestedComments(
              withPostId: postId, commentId: commentId, ownerId: ownerId
            ).sink { completion in
              if case .failure(let error) = completion {
                // TODO: - 로그에 기록. 어느 대댓글id를 받아올때 에러를 갖는지 형식이 잘못됬는지 에러도 저장하고
                print(error)
                atomicToNestedCommentGroup.leave()
              }
            } receiveValue: { postNestedComments in
              nestedComments = postNestedComments
              atomicToNestedCommentGroup.leave()
            }
            subscriptions.insert(fetchNestedComments)
            
            atomicToNestedCommentGroup.enter()
            hasBlocked = ownerRepository.hasBlockedUser(with: atomicCommentEntity.authorId)
            atomicToNestedCommentGroup.leave()
            
            atomicToNestedCommentGroup.notify(queue: backgroundQueue) { [weak self, i] in
              if let commentAuthor, let hasBlocked, let isOnHeart {
                let postComment = self?.makePostCommentEntity(
                  atomicCommentEntity: atomicCommentEntity, commentAuthor: commentAuthor,
                  isOnHeart: isOnHeart, isBlocked: hasBlocked, nestedComments: nestedComments)
                postComments.append((i, postComment))
              } else {
                postComments.append((i, nil))
              }
              postCommentsGroupManager.leave()
            }
          }
          postCommentsGroupManager.notify(queue: backgroundQueue) {
            promise(.success(postComments.sorted(by: {$0.index < $1.index}).compactMap { $1 }))
          }
        }
      self?.subscriptions.insert(fetchComments)
    }.eraseToAnyPublisher()
  }
  
  private func makePostCommentEntity(
    atomicCommentEntity: PostAtomicCommentEntity,
    commentAuthor: UserEntity,
    isOnHeart: Bool,
    isBlocked: Bool,
    nestedComments: [PostNestedCommentEntity]
  ) -> PostCommentEntity {
    return PostCommentEntity(
      commentId: atomicCommentEntity.commentId,
      userName: commentAuthor.nickname,
      timestamp: DateTimeConverter.timeAgo(from: atomicCommentEntity.createAt),
      comment: atomicCommentEntity.comment,
      isDeleted: atomicCommentEntity.hasDeleted,
      isOnHeart: isOnHeart,
      isBlocked: isBlocked,
      hearts: Int32(atomicCommentEntity.hearts),
      nestedComments: nestedComments)
  }
}

// MARK: - Private Helpers
private extension PostCommentUseCaseImpl {
  typealias UserIdentifier = String
  func logNetworkError(error: Error, fromEntity entity: Any) {
    os_log("[네트워크 에러] 사용자 정보 받아오는 도중 에러 발생 Error: %@\n fromEntity: %@",
           log: .init(subsystem: "com.yeoga.app", category: "network"),
           type: .error,
           error.localizedDescription,
           String(describing: entity))
  }
  
  private func fetchUserProfileEntity(with userId: String) -> AnyPublisher<UserEntity, any Error> {
    return userProfileRepository.fetchProfile(with: userId)
  }
  
  private func fetchAtomicNestedComments(
    postId: String,
    commentId: String
  ) -> AnyPublisher<[PostAtomicNestedCommentEntity], any Error> {
    return postNestedCommentRepository.fetchNestedComments(postId: postId, commentId: commentId)
  }
  
  private func fetchNestedCommentHeartUsers(
    postId: String,
    commentId: String,
    nestedCommentId: String
  ) -> AnyPublisher<[UserIdentifier], any Error> {
    return postNestedCommentHeartRepository
      .fetchNestedCommentHeartUsers(with: postId, commentId: commentId, nestedCommentId: nestedCommentId)
  }
  
  private func fetchCommentHeartUsers(
    postId: String,
    commentId: String
  ) -> AnyPublisher<[UserIdentifier], any Error> {
    return postCommentHeartRepository.fetchCommentHeartUsers(with: postId, commentId: commentId)
  }
  
  private func makePostNestedCommentEntity(
    authorEntity: UserEntity,
    postAtomicNestedComment: PostAtomicNestedCommentEntity,
    nestedCommentHeartUsers: [String],
    ownerId: String
  ) -> PostNestedCommentEntity {
    let isOnHeart = hasOwnerHeartedSpecificComment(ownerId, from: nestedCommentHeartUsers)
    return PostNestedCommentEntity(
      nestedCommentId: postAtomicNestedComment.nestedCommentId,
      authorId: authorEntity.id,
      userProfileImageData: authorEntity.profileImageData,
      nickname: authorEntity.nickname,
      timestamp: DateTimeConverter.timeAgo(from: postAtomicNestedComment.createAt),
      comment: postAtomicNestedComment.comment,
      hearts: Int32(postAtomicNestedComment.hearts),
      isOnHeart: isOnHeart)
  }
  
  private func hasOwnerHeartedSpecificComment(
    _ ownerId: UserIdentifier,
    from specificCommentHeartUserIdentifiers: [UserIdentifier]
  ) -> Bool {
    return specificCommentHeartUserIdentifiers.contains { $0 == ownerId }
  }
  
  private func fetchIndexedNestedComments(
    withPostId postId: String,
    commentId: String,
    ownerId: String
  ) -> AnyPublisher<[PostNestedCommentEntity], any Error> {
    return fetchAtomicNestedComments(postId: postId, commentId: commentId)
      .flatMap { postAtomicNestedComments in
        /// 대댓글 sequence마다 작성한 사용자 프로필 및 owner가 대댓글을 좋아했는지 여부 파악합니다.
        return Publishers.Sequence(sequence: postAtomicNestedComments.enumerated())
          .receive(on: DispatchQueue.global(qos: .userInitiated))
          .flatMap { [weak self] index, postAtomicNestedComment -> AnyPublisher<IndexedNestedComment?, Error> in
            guard let self else { return Fail(error: ReferenceError.invalidReference).eraseToAnyPublisher() }
            /// 차단된 유저 대댓글이라면 대댓글에 포함하지 않습니다.
            if ownerRepository.hasBlockedUser(with: postAtomicNestedComment.authorId) {
              return Just(nil).setFailureType(to: (any Error).self).eraseToAnyPublisher()
            }
            return Publishers.Zip(
              fetchUserProfileEntity(with: postAtomicNestedComment.authorId),
              fetchNestedCommentHeartUsers(
                postId: postId, commentId: commentId, nestedCommentId: postAtomicNestedComment.nestedCommentId))
            .tryMap { [weak self] nestedCommentAuthorEntity, nestedCommentHeartUsers -> IndexedNestedComment in
              guard let self else { throw ReferenceError.invalidReference }
              let nestedCommentEntity = makePostNestedCommentEntity(
                authorEntity: nestedCommentAuthorEntity,
                postAtomicNestedComment: postAtomicNestedComment,
                nestedCommentHeartUsers: nestedCommentHeartUsers,
                ownerId: ownerId)
              return (index, nestedCommentEntity)
            }.eraseToAnyPublisher()
          }.eraseToAnyPublisher()
          .collect(postAtomicNestedComments.count)
          .map { indexedNestedComments -> [PostNestedCommentEntity] in
            return indexedNestedComments
              .compactMap { $0 }
              .sorted(by: { $0.indexForSorting < $1.indexForSorting })
              .map { $1 }
          }
          .eraseToAnyPublisher()
      }.eraseToAnyPublisher()
  }
}
