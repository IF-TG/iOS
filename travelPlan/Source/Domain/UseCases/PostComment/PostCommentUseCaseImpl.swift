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
  typealias IndexedNestedComment = (indexForSorting: Int, nestedCommentEntity: PostNestedCommentEntity)
  
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
  // MARK: - Comemnt send
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
  
  // MARK: - Comment update
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
  
  // MARK: - Comment delete
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
  
  // MARK: - Comments fetch
  // swiftlint:disable:next function_body_length
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
          
          /// 각각의 atomic 댓글마다 달려있는 atomic 대댓글들, 해당 작성자의 프로필 정보를 받아옵니다.
          for (i, atomicCommentEntity) in atomicCommentEntities.enumerated() {
            postCommentsGroupManager.enter()
            let atomicToNestedCommentGroup = DispatchGroup(), commentId = atomicCommentEntity.commentId
            var commentAuthor: UserEntity?, hasBlocked: Bool?, isOnHeart: Bool?
            var nestedComments: [PostNestedCommentEntity] = []
            
            atomicToNestedCommentGroup.enter()
            let fetchNestedCommentAuthorProfile = Publishers.Zip(
              fetchUserProfileEntity(with: atomicCommentEntity.authorId),
              fetchCommentHeartUsers(postId: postId, commentId: commentId))
              .sink { [weak self] completion in
                if case .failure(let error) = completion {
                  self?.logFetchNestedCommentAuthorError(
                    error: error, authorId: commentAuthor?.id, postId: postId, commentId: commentId)
                  atomicToNestedCommentGroup.leave()
                }
              } receiveValue: { commentAuthorEntity, commentHeartUsers in
                commentAuthor = commentAuthorEntity
                isOnHeart = commentHeartUsers.contains { $0 == ownerId }
                atomicToNestedCommentGroup.leave()
              }
            subscriptions.insert(fetchNestedCommentAuthorProfile)
            
            atomicToNestedCommentGroup.enter()
            let fetchNestedComments = fetchIndexedNestedComments(
              withPostId: postId, commentId: commentId, ownerId: ownerId
            ).sink { [weak self] completion in
              if case .failure(let error) = completion {
                self?.logFetchNestedCommentsError(error: error, postId: postId, commentId: commentId)
                atomicToNestedCommentGroup.leave()
              }
            } receiveValue: { postNestedComments in
              nestedComments = postNestedComments
              atomicToNestedCommentGroup.leave()
            }
            subscriptions.insert(fetchNestedComments)
            
            /// 해당 댓글을을 단 author를 owner가 차단했는지 여부를 받습니다.
            atomicToNestedCommentGroup.enter()
            hasBlocked = ownerRepository.hasBlockedUser(with: atomicCommentEntity.authorId)
            atomicToNestedCommentGroup.leave()
            
            /// 하나의 댓글을 달은 저자 profile 해당 저자 차단 여부, 댓글에 달린 대댓글들, 대댓글 각각의 저자 프로필, 그 대댓글 각각의 저자를 차단했는지 여부를 판단합니다.
            /// 결과로 하나의 댓글 엔터티를 만듭니다.
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
          /// 최종적으로 하위 스트림한테 값 방출을 promise합니다.
          /// 에러가 발생된 댓글 or 대댓글은 제외, 차단한 사용자도 제외하도록 처리된 댓글들과 대댓글들이 반환됩니다.
          postCommentsGroupManager.notify(queue: backgroundQueue) {
            promise(.success(postComments.sorted(by: {$0.index < $1.index}).compactMap { $1 }))
          }
        }
      self?.subscriptions.insert(fetchComments)
    }.eraseToAnyPublisher()
  }
}

// MARK: - Private Helpers
private extension PostCommentUseCaseImpl {
  typealias UserIdentifier = String
  
  // MARK: - Comment send Helpers
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
        authorId: author.id,
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
  
  // MARK: - Comment delete Helpers
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
  
  private func makePostCommentEntity(
    atomicCommentEntity: PostAtomicCommentEntity,
    commentAuthor: UserEntity,
    isOnHeart: Bool,
    isBlocked: Bool,
    nestedComments: [PostNestedCommentEntity]
  ) -> PostCommentEntity {
    return PostCommentEntity(
      commentId: atomicCommentEntity.commentId, 
      authorId: commentAuthor.id,
      userName: commentAuthor.nickname,
      timestamp: DateTimeConverter.timeAgo(from: atomicCommentEntity.createAt),
      comment: atomicCommentEntity.comment,
      isDeleted: atomicCommentEntity.hasDeleted,
      isOnHeart: isOnHeart,
      isBlocked: isBlocked,
      hearts: Int32(atomicCommentEntity.hearts),
      nestedComments: nestedComments)
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
            /// 각각의 스레드에서 비동기적으로 대댓글의 사용자 프로필, 대댓글에서 하트한 사용자 리스트를 받아와 PostNestedCommentEntity를 반환합니다.
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
            /// 위 작업은 각각의 스레드에서 비동기적으로 작업되기에 호출된 요청에 따라 순차적으로 결과가 변환되는게 아니라서 sorting이 필수입니다.
            return indexedNestedComments
              .compactMap { $0 }
              .sorted(by: { $0.indexForSorting < $1.indexForSorting })
              .map { $1 }
          }
          .eraseToAnyPublisher()
      }.eraseToAnyPublisher()
  }
  
  // MARK: - log Helpers
  func logNetworkError(error: Error, fromEntity entity: Any) {
    os_log("[네트워크 에러] 사용자 정보 받아오는 도중 에러 발생 Error: %@\n fromEntity: %@",
           log: .init(subsystem: "com.yeoga.app", category: "network"),
           type: .error,
           error.localizedDescription,
           String(describing: entity))
  }
  
  func logFetchNestedCommentAuthorError(
    error: Error,
    authorId: String?,
    postId: String,
    commentId: String
  ) {
    os_log("[네트워크 에러] 사용자 정보 받아오는 도중 에러 발생 Error: %@\n authorId: %@, postId: %@, commentId: %@",
           log: .init(subsystem: "com.yeoga.app", category: "network"),
           type: .error,
           error.localizedDescription,
           authorId ?? "authorId가 비었습니다.",
           postId,
           commentId)
  }
  
  func logFetchNestedCommentsError(
    error: Error,
    postId: String,
    commentId: String
  ) {
    os_log("[네트워크 에러] 대댓글 정보를 받아오는 도중 에러 발생 Error: %@\n postId: %@, commentId: %@",
           log: .init(subsystem: "com.yeoga.app", category: "network"),
           type: .error,
           error.localizedDescription,
           postId,
           commentId)
  }
}
