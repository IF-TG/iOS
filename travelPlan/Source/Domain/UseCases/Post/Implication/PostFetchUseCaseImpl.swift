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
  
  // MARK: - Dependencies
  private let postFetchAtomicRepository: PostFetchAtomicRepository
  
  private let userProfileRepository: UserProfileRepository
  
  private let postHeartRepository: PostHeartRepository
  
  // MARK: - Properties
  private let pageSize = 10
  
  // MARK: - Lifecycle
  init(
    postFetchAtomicRepository: PostFetchAtomicRepository,
    userProfileRepository: UserProfileRepository,
    postHeartRepository: PostHeartRepository
  ) {
    self.postFetchAtomicRepository = postFetchAtomicRepository
    self.userProfileRepository = userProfileRepository
    self.postHeartRepository = postHeartRepository
  }
}

// MARK: - PostFetchUseCase
extension PostFetchUseCaseImpl: PostFetchUseCase {
  func fetchFilteredPosts(
    with page: PostFetchRequestValue
  ) -> AnyPublisher<PostsPage, any Error> {
    return postFetchAtomicRepository
      .fetchFilteredPosts(page: page.page, perPage: Int32(pageSize), category: page.category)
      .flatMap { atomicPosts in
        let collectCount = atomicPosts.count
        let indexedUserPublishers: [IndexedUserPublisher] = atomicPosts
          .enumerated()
          .map { index, atomicPost in
            return userProfileRepository
              .fetchProfile(with: atomicPost.authorId)
              .map { userEntity -> IndexedUserEntity in
                return (index, userEntity)
              }.eraseToAnyPublisher()
          }
        
        // TODO: - Owner가 해당 포스트 좋아했는지 가져와야합니다.
        let hasLikedPost: [Bool] = atomicPosts.map { atomicPost in
          atomicPost.authorId 
        }
        
        
        
        return Publishers.MergeMany(indexedUserPublishers)
          .collect(collectCount)
          .eraseToAnyPublisher()
          .map { indexedUserEntities -> [UserEntity] in
            return indexedUserEntities
              .sorted(by: {$0.index < $1.index })
              .map { $0.user }
          }.eraseToAnyPublisher()
          .map { postAuthors in
            let posts: [Post] = (0..<postAuthors.count).map { index in
              let atomicPost = atomicPosts[index]
              let postAuthor = postAuthors[index]
              return Post(liked: <#T##Bool#>, atomicPost: atomicPost, postAuthor: postAuthor)
            }
          }
          
      }
  }
}
