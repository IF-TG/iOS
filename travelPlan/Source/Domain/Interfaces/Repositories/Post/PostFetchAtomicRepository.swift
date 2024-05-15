//
//  PostFetchAtomicRepository.swift
//  travelPlan
//
//  Created by 양승현 on 5/15/24.
//

import Combine
import Foundation

@frozen enum PostFetchAtomicRepositoryError: Error {
  case documentNotFound
  case noMorePage
  case invalidSelfReference
  case serviceError(Error)
  case invalidOwnerId
}

protocol PostFetchAtomicRepository {
  /// Category에 따른 query를 반환하빈다.
  func fetchFilteredPosts(
    page: Int32,
    perPage: Int32,
    category: PostCategory
  ) -> AnyPublisher<[AtomicPost], any Error>
  
  func fetchOwnerLikedPosts(
    page: Int32,
    perPage: Int32,
    likedPostIdList: [String]
  ) -> AnyPublisher<[AtomicPost], any Error>
  
  func fetchOwnerWrotePosts(
    isFirstPage: Bool,
    perPage: Int32
  ) -> AnyPublisher<[AtomicPost], any Error>
}
