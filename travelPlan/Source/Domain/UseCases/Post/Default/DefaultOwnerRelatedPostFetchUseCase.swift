//
//  DefaultOwnerRelatedPostFetchUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 5/16/24.
//

import Combine
import Foundation

final class DefaultOwnerRelatedPostFetchUseCase: OwnerRelatedPostFetchUseCase {
  // MARK: - Dependencies
  private let postRepository: PostRepository
  
  // MARK: - Lifecycle
  init(postRepository: PostRepository) {
    self.postRepository = postRepository
  }
  
  func fetchOwnerLikedPosts(
    page: Int32,
    perPage: Int32
  ) -> AnyPublisher<PostsPage, any Error> {
    return postRepository
      .fetchLikedPostsByLoggedInUser(page: page, perPage: perPage)
  }
  
  func fetchOwnerWrotePosts(
    isFirstPage: Bool, 
    perPage: Int32
  ) -> AnyPublisher<PostsPage, any Error> {
    fatalError("spring 서버에서 미 구현된 api입니다")
  }
}
