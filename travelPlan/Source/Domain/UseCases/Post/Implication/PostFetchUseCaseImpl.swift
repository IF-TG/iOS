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
  typealias PostIdentifier = String
  
  // MARK: - Dependencies
  private let postFetchAtomicRepository: PostFetchAtomicRepository
  
  private let userProfileRepository: UserProfileRepository
  
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
extension PostFetchUseCaseImpl: PostFetchUseCase {
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
      
      let hasHeartPost: [Bool] = atomicPosts.map { atomicPost -> Bool in
        return self.hasOwnerHeartPost(ownerheartPostIdentifiers, postId: atomicPost.detail.postID)
      }
      
      let collectCount = atomicPosts.count
      let indexedUserPublishers: [IndexedUserPublisher] = atomicPosts
        .enumerated()
        .compactMap { [weak self] index, atomicPost -> AnyPublisher<IndexedUserEntity, any Error>? in
          return self?.userProfileRepository
            .fetchProfile(with: atomicPost.authorId)
            .map { userEntity -> IndexedUserEntity in
              return (index, userEntity)
            }.eraseToAnyPublisher()
        }

      return Publishers.MergeMany(indexedUserPublishers)
        .collect(collectCount)
        .eraseToAnyPublisher()
        .map { indexedUserEntities -> PostsPage in
          let authors = indexedUserEntities
            .sorted(by: {$0.index < $1.index })
            .map { $0.user }
          
          let posts: [Post] = (0..<authors.count).map { index in
            let atomicPost = atomicPosts[index]
            let author = authors[index]
            let hasHeart = hasHeartPost[index]
            let postAuthor = Post.Author(
              profileImageData: author.profileImageData,
              nickname: author.nickname,
              authorId: author.id)
            
            return Post(liked: hasHeart, atomicPost: atomicPost, postAuthor: postAuthor)
          }
          let postPage = PostsPage(posts: posts, thumbnails: [])
          return postPage
        }.eraseToAnyPublisher()
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
