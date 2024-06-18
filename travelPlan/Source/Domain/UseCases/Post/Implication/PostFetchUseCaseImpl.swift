//
//  PostFetchUseCaseImpl.swift
//  travelPlan
//
//  Created by 양승현 on 5/16/24.
//

import Combine
import Foundation

final class PostFetchUseCaseImpl {
  typealias IndexedUserEntity = (index: Int, user: UserEntity)
  typealias IndexedUserPublisher = AnyPublisher<IndexedUserEntity, any Error>
  typealias FilteredPostsOutput = AnyPublisher<PostsPage, any Error>
  
  // MARK: - Dependencies
  private let postFetchAtomicRepository: PostFetchAtomicRepository
  
  internal let userProfileRepository: UserProfileRepository
  
  private let postHeartRepository: PostHeartRepository
  
  private let ownerHeartPostRepository: OwnerHeartPostRepository
  
  private let backgroundQueue: DispatchQueue
  
  // MARK: - Properties
  private let pageSize = 10
  
  // MARK: - Lifecycle
  init(
    postFetchAtomicRepository: PostFetchAtomicRepository,
    userProfileRepository: UserProfileRepository,
    postHeartRepository: PostHeartRepository,
    ownerHeartPostRepository: OwnerHeartPostRepository,
    backgroundQueue: DispatchQueue = DispatchQueue(
      label: "PostFetcuUseCaseImpl.com", qos: .userInitiated, attributes: .concurrent)
  ) {
    self.postFetchAtomicRepository = postFetchAtomicRepository
    self.userProfileRepository = userProfileRepository
    self.postHeartRepository = postHeartRepository
    self.ownerHeartPostRepository = ownerHeartPostRepository
    self.backgroundQueue = backgroundQueue
  }
}

// MARK: - PostFetchUseCase
extension PostFetchUseCaseImpl: PostFetchUseCase, PostsPageCreatable {
  func fetchPost(
    with postId: PostIdentifier
  ) -> AnyPublisher<Post, any Error> {
    fatalError("현재 spring server를 다시 사용하기에 firestore를 사용하지 않지만, 다시 firestore 사용해야한다면 이 함수 구현해야합니다.")
  }
  
  func fetchFilteredPosts(
    with page: PostFetchRequestValue
  ) -> FilteredPostsOutput {
    return Publishers.Zip(
      makeFilteredPostsFetchPublisher(with: page),
      makeOwnerHeartPostIdentifiersFetchPublisher())
    .receive(on: backgroundQueue)
    .flatMap { [weak self] atomicPosts, ownerheartPostIdentifiers -> FilteredPostsOutput in
      guard let self else {
        return Fail(error: ReferenceError.invalidReference).eraseToAnyPublisher()
      }
      
      let hasHeartPost: [Bool] = atomicPosts.compactMap { [weak self] atomicPost -> Bool? in
        // MARK: - Firestore를 사용하게 될 경우 uuid는 String을 사용해야 합니다.
        return self?.hasOwnerHeartPost(ownerheartPostIdentifiers, postId: atomicPost.detail.postID)
      }
      
      return  makePostsPage(atomicPosts: atomicPosts, hasOwnerHeartEachPost: hasHeartPost)
    }.eraseToAnyPublisher()
  }
}

// MARK: - Helpers
private extension PostFetchUseCaseImpl {
  func makeFilteredPostsFetchPublisher(
    with page: PostFetchRequestValue
  ) -> AnyPublisher<[AtomicPost], any Error> {
    return postFetchAtomicRepository.fetchFilteredPosts(
      page: page.page,
      perPage: Int32(pageSize),
      category: page.category)
  }
  
  func makeOwnerHeartPostIdentifiersFetchPublisher() -> AnyPublisher<[PostIdentifier], any Error> {
    return ownerHeartPostRepository.fetchOwnerHeartPostIdentifiers()
  }
  
  func hasOwnerHeartPost(_ ownerHeartPostIdentifiers: [PostIdentifier], postId: PostIdentifier) -> Bool {
    return ownerHeartPostIdentifiers.contains { $0 == postId }
  }
}
