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
    return postAtomicCommentRepository.fetchComments(postId: postId)
      .flatMap { [weak self] atomicCommentEntities -> AnyPublisher<[PostCommentEntity], any Error> in
        guard let self else { return Fail(error: ReferenceError.invalidReference).eraseToAnyPublisher() }
        
        /// 로그인이 반드시 된다면 ownerId가 반드시 있긴 합니다..
        guard let ownerId = ownerRepository.id else {
          return Fail(error: LoggedInUserRepositoryError.invalidUserId).eraseToAnyPublisher()
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
          let fetchNestedComments = Publishers.Zip3(
            fetchUserProfileEntity(with: atomicCommentEntity.authorId),
            fetchAtomicNestedComments(postId: postId, commentId: commentId),
            fetchCommentHeartUsers(postId: postId, commentId: commentId))
            .flatMap { commentAuthorEntity, postAtomicNestedComments, commentHeartUsers in
              commentAuthor = commentAuthorEntity
              isOnHeart = commentHeartUsers.contains { $0 == ownerId }
              // TODO: - 여기선 대댓글 단 사용자 profile 받아와야합니다.
              // 아.. 포스트 하트 컬랙션에서 하트했는지 여부도 파악해야합니다 ㅠ..
              return Publishers.Sequence(sequence: postAtomicNestedComments.enumerated())
                .receive(on: DispatchQueue.global(qos: .userInitiated))
                .flatMap { [weak self] index, postAtomicNestedComment -> AnyPublisher<IndexedNestedComment, Error> in
                  guard let self else { return Fail(error: ReferenceError.invalidReference).eraseToAnyPublisher() }
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
                    .sorted(by: { $0.indexForSorting < $1.indexForSorting })
                    .map { $1 }
                }.eraseToAnyPublisher()
              // TODO: - 대댓글에 차단한 유저 어떻게하지?
              // .filter(<#T##isIncluded: ([PostNestedCommentEntity]) -> Bool##([PostNestedCommentEntity]) -> Bool#>)
            }.sink { completion in
              // FIXME: 자 에러처리 잘 해보자. 복잡한데.
              // 하나로 뭉쳐
              fatalError("거의다옴")
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
          return Just(postComments.sorted(by: {$0.index < $1.index}).compactMap { $1 })
        }
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
}
