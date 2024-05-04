//
//  FirestorePostCommentRepository.swift
//  travelPlan
//
//  Created by 양승현 on 5/4/24.
//

import Combine
import Foundation
import FirebaseFirestore
import SHFirestoreService

@frozen enum FirestorePostCommentRepostioryError: LocalizedError {
  case invalidParameter
  case invalidSelfReference
  
  var errorDescription: String? {
    switch self {
    case .invalidParameter:
      return "Invalid function's input parameter"
    case .invalidSelfReference:
      return "Invalid self reference"
    }
  }
}

final class FirestorePostCommentRepository {
  typealias Endpoint = FirestorePostCommentAPIEndpoint
  
  // MARK: - Dependencies
  private let backgroundQueue: DispatchQueue
  private let service: FirestoreServiceProtocol
  private let firebaseStorageService: ImageStorageServiceProtocol
  private let imageCache: ImageMemoryCachable
  private let loggedInUserRepository: LoggedInUserRepository
  private let myProfileRepository: MyProfileRepository
  
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable?>()
  
  // MARK: - Lifecycle
  init(
    service: FirestoreServiceProtocol,
    backgroundQueue: DispatchQueue = .global(qos: .userInitiated),
    firebaseStorageService: ImageStorageServiceProtocol,
    loggedInUserRepository: LoggedInUserRepository,
    myProfileRepository: MyProfileRepository,
    imageCache: ImageMemoryCachable
  ) {
    self.service = service
    self.loggedInUserRepository = loggedInUserRepository
    self.backgroundQueue = backgroundQueue
    self.firebaseStorageService = firebaseStorageService
    self.myProfileRepository = myProfileRepository
    self.imageCache = imageCache
  }
}

// MARK: - PostCommentRepository
extension FirestorePostCommentRepository: PostCommentRepository {
  func sendComment(
    postId: String,
    comment: String
  ) -> AnyPublisher<PostCommentEntity, any Error> {
    
    guard let ownerId = loggedInUserRepository.id else {
      return Fail(error: LoggedInUserRepositoryError.invalidUserId).eraseToAnyPublisher()
    }
    let commentId = UUID().uuidString
    
    let requestDTO = FirestorePostCommentSendRequestDTO(
      commentId: commentId,
      authorId: ownerId,
      createAt: Timestamp(date: Date()),
      comment: comment,
      hasDeleted: false,
      heartNum: 0)
    let endpoint = Endpoint.makeCommentSendEndpoint(postId: postId, commentId: commentId, with: requestDTO)
    
    return Future { [weak self, backgroundQueue] promise in
      // FIXME: - 저장할 경우 backgroundTask로 추가해야합니다.
      guard let self else {
        promise(.failure(ReferenceError.invalidReference))
        return
      }
      
      let requestSubscription = service.saveDocument(endpoint: endpoint)
        .subscribe(on: backgroundQueue)
        .receive(on: backgroundQueue)
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { [weak self] _ in
          var owner: UserEntity?
          let group = DispatchGroup()
          group.enter()
          if let loggedInUser = self?.loggedInUserRepository.user {
            owner = loggedInUser
            group.leave()
          } else {
            let ownerProfileSubscription = self?.myProfileRepository.fetchProfile(with: ownerId)
              .sink { completion in
                if case .failure(let error) = completion {
                  promise(.failure(error))
                }
              } receiveValue: { userEntity in
                owner = userEntity
                self?.loggedInUserRepository.setUser(with: userEntity)
                group.leave()
              }
            self?.subscriptions.insert(ownerProfileSubscription)
          }
          
          // FIXME: - TimestampConverter로 timestamp 변환해야합니다. (timeAgo 사용!)
          self?.handleCommentSend(owner: owner, requestDTO: requestDTO, with: group, promise: promise)
        }
      subscriptions.insert(requestSubscription)
    }.eraseToAnyPublisher()
  }
  
  private func handleCommentSend(
    owner: UserEntity?,
    requestDTO: FirestorePostCommentSendRequestDTO,
    with group: DispatchGroup,
    promise: @escaping Future<PostCommentEntity, Error>.Promise
  ) {
    group.notify(queue: backgroundQueue) {
      guard let owner else { return }
      let commentEntity = PostCommentEntity(
        commentId: requestDTO.commentId,
        userProfileImageData: owner.profileImageData,
        userName: owner.nickname,
        timestamp: String(requestDTO.createAt.dateValue().description),
        comment: requestDTO.comment,
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
    guard let postId else {
      return Fail(error: FirestorePostCommentRepostioryError.invalidParameter).eraseToAnyPublisher()
    }
    let requestDTO = PostCommentUpdateRequestDTO(commentId: commentId, comment: comment)
    let endpoint = Endpoint.makeCommentUpdateEndpoint(postId: postId, with: requestDTO)
    
    return Future { [weak self] promise in
      guard let self else {
        promise(.failure(FirestorePostCommentRepostioryError.invalidSelfReference))
        return
      }
      
      // FIXME: -  backgroundTask 도 추가해야합니다.
      let requestSubscription = self.service
        .request(endpoint: endpoint)
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { _ in
          promise(.success(true))
        }
      subscriptions.insert(requestSubscription)
    }.eraseToAnyPublisher()
  }
  
  func deleteComment(
    postId: String?,
    commentId: String
  ) -> AnyPublisher<Bool, any Error> {
    // TODO: - 해당 포스트 댓글의 nestedComment 개수 받아와야합니다.
    var hasAnyNestedCommentExisted = false
    
    if hasAnyNestedCommentExisted {
      // TODO: - 네스티드 커맨츠 있을떄 엔드포인트 사용
    } else {
      // TODO: - 델리트커멘트 엔드포인트 사용
    }
    fatalError("미구현")
  }
  
  func fetchComments(
    page: Int32,
    perPage: Int32,
    postId: String
  ) -> AnyPublisher<[PostCommentEntity], any Error> {
    fatalError("미구현")
  }
  
  func toggleCommentHeart(
    postId: String?,
    commentId: String
  ) -> AnyPublisher<ToggledPostCommentHeartEntity, any Error> {
    fatalError("미구현")
  }
}
