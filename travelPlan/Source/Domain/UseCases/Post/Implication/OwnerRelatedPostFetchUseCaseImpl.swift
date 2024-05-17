//
//  OwnerRelatedPostFetchUseCaseImpl.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/17/24.
//

import Combine
import Foundation

final class OwnerRelatedPostFetchUseCaseImpl {
  typealias IndexedUserEntity = (index: Int, user: UserEntity)
  typealias IndexedUserPublisher = AnyPublisher<IndexedUserEntity, any Error>
  
  // MARK: - Dependencies
  private let postAtomicRepository: PostFetchAtomicRepository
  private let ownerHeartPostRepository: OwnerHeartPostRepository
  internal let userProfileRepository: UserProfileRepository
  private let ownerRepository: LoggedInUserRepository
  // MARK: - Properties
  
  
  // MARK: - Lifecycle
  init(
    postAtomicRepository: PostFetchAtomicRepository,
    ownerHeartPostRepository: OwnerHeartPostRepository,
    userProfileRepository: UserProfileRepository,
    ownerRepository: LoggedInUserRepository
  ) {
    self.postAtomicRepository = postAtomicRepository
    self.ownerHeartPostRepository = ownerHeartPostRepository
    self.userProfileRepository = userProfileRepository
    self.ownerRepository = ownerRepository
  }
  
}

// MARK: - OwnerRelatedPostFetchUseCase
extension OwnerRelatedPostFetchUseCaseImpl: OwnerRelatedPostFetchUseCase, PostsPageCreatable {
  func fetchOwnerLikedPosts(
    page: Int32,
    perPage: Int32
  ) -> AnyPublisher<PostsPage, any Error> {
    return ownerHeartPostRepository
      .fetchOwnerHeartPostIdentifiers()
      .flatMap { [weak self] ownerHeartPostIdentifiers -> AnyPublisher<PostsPage, any Error> in
        guard let self else { return Fail(error: ReferenceError.invalidReference).eraseToAnyPublisher() }
        return postAtomicRepository
          .fetchOwnerLikedPosts(page: page, perPage: perPage, likedPostIdList: ownerHeartPostIdentifiers)
          .flatMap { [weak self] atomicPosts -> AnyPublisher<PostsPage, any Error> in
            let numberOfAtomicPosts = atomicPosts.count
            guard let self else { return Fail(error: ReferenceError.invalidReference).eraseToAnyPublisher() }
            
            return makePostsPage(
              atomicPosts: atomicPosts,
              hasOwnerHeartEachPost: (0..<numberOfAtomicPosts).map { _ in true })
              
          }.eraseToAnyPublisher()
      }.eraseToAnyPublisher()
  }
  
  func fetchOwnerWrotePosts(
    isFirstPage: Bool,
    perPage: Int32 = 10
  ) -> AnyPublisher<PostsPage, any Error> {
    /// 로그인한 사용자는 반드시 user info가 있어야 합니다.
    guard let owner = ownerRepository.user else {
      return Fail(error: OwnerError.invalidOwnerId).eraseToAnyPublisher()
    }
    
    return Publishers.Zip(
      ownerHeartPostRepository.fetchOwnerHeartPostIdentifiers(),
      postAtomicRepository.fetchOwnerWrotePosts(isFirstPage: isFirstPage, perPage: perPage))
    .flatMap { [weak self] ownerHeartPostIdentifiers, atomicPosts -> AnyPublisher<PostsPage, any Error> in
      guard let self else { return Fail(error: ReferenceError.invalidReference).eraseToAnyPublisher() }
      let hasOwnerPostsHeart = atomicPosts.map { atomicPost -> Bool in
        return ownerHeartPostIdentifiers.contains { $0 == atomicPost.detail.postID }
      }
      return makePostsPage(atomicPosts: atomicPosts, hasOwnerHeartEachPost: hasOwnerPostsHeart)
    }.eraseToAnyPublisher()
  }
}
