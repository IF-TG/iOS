//
//  PostsPageCreatable.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/17/24.
//

import Combine
import Foundation

protocol PostsPageCreatable: AnyObject {
  typealias IndexedUserEntity = (index: Int, user: UserEntity)
  typealias IndexedUserPublisher = AnyPublisher<IndexedUserEntity, any Error>
  
  var userProfileRepository: UserProfileRepository { get }
}

extension PostsPageCreatable {
  /// Owner가  atomicPosts를 좋아했는지 여부로 PostsPage를 만듭니다.
  ///
  /// - param hasOwnerHeartEachPost: atomicPosts 각각에 대해 Owner가 heart했는지 여부를 담아야합니다.
  func makePostsPage(
    atomicPosts: [AtomicPost],
    hasOwnerHeartEachPost hasHeartEachPost: [Bool]
  ) -> AnyPublisher<PostsPage, any Error> {
    let collectCount = atomicPosts.count
    let indexedUserPublishers: [IndexedUserPublisher] = atomicPosts
      .enumerated()
      .compactMap { [weak self] index, atomicPost -> IndexedUserPublisher? in
        return self?.userProfileRepository
          .fetchProfile(with: atomicPost.authorId)
          .map { userEntity -> IndexedUserEntity in
            return (index, userEntity)
          }.eraseToAnyPublisher()
      }
    
    return Publishers.MergeMany(indexedUserPublishers)
      .collect(collectCount)
      .eraseToAnyPublisher()
      .toPostsPage(fromAtomicPosts: atomicPosts, hasOwnerHeartEachPost: hasHeartEachPost)
  }
}

// MARK: - Publisher+Helpers
fileprivate extension Publisher
where Output == [PostsPageCreatable.IndexedUserEntity], Failure == any Error {
  func toPostsPage(
    fromAtomicPosts atomicPosts: [AtomicPost],
    hasOwnerHeartEachPost hasHeartEachPost: [Bool]
  ) -> AnyPublisher<PostsPage, Self.Failure> {
    return self.map { indexedUserEntities -> PostsPage in
      let numberOfPosts = indexedUserEntities.count
      let authors = indexedUserEntities
        .sorted { $0.index < $1.index }
        .map { $0.user }
      
      let posts: [Post] = (0..<numberOfPosts).map { index in
        let atomicPost = atomicPosts[index]
        let author = authors[index]
        let hasHeart = hasHeartEachPost[index]
        let postAuthor = Post.Author(
          profileImageData: author.profileImageData,
          nickname: author.nickname,
          authorId: author.id)
        return Post(liked: hasHeart, atomicPost: atomicPost, postAuthor: postAuthor)
      }
      return PostsPage(posts: posts, thumbnails: [])
    }.eraseToAnyPublisher()
  }
}
