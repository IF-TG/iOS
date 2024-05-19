//
//  DefaultPostFetchUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 5/16/24.
//

import Combine
import Foundation

final class DefaultPostFetchUseCase: PostFetchUseCase {
  // MARK: - Dependencies
  private let postRepository: PostRepository
  
  // MARK: - Lifecycle
  init(postRepository: PostRepository) {
    self.postRepository = postRepository
  }
  
  func fetchFilteredPosts(
    with page: PostFetchRequestValue
  ) -> AnyPublisher<PostsPage, any Error> {
    return postRepository
      .fetchPosts(page: page.page, perPage: page.perPage, category: page.category)
  }
}
