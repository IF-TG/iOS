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
  // MARK: - Properties
  
  
  // MARK: - Lifecycle
  init(
    postAtomicRepository: PostFetchAtomicRepository,
    ownerHeartPostRepository: OwnerHeartPostRepository,
    userProfileRepository: UserProfileRepository
  ) {
    self.postAtomicRepository = postAtomicRepository
    self.ownerHeartPostRepository = ownerHeartPostRepository
    self.userProfileRepository = userProfileRepository
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
}
