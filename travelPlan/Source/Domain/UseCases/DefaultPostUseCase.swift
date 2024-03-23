//
//  DefaultPostUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 3/8/24.
//

import Foundation
import Combine

final class DefaultPostUseCase: PostUseCase {
  // MARK: - Dependencies
  private let postRepository: PostRepository
  
  // MARK: - Lifecycle
  init(postRepository: PostRepository) {
    self.postRepository = postRepository
  }
  
  func fetchPosts(with page: PostFetchRequestValue) -> AnyPublisher<[PostContainer], any Error> {
    return postRepository.fetchPosts(
      page: page.page,
      perPage: page.perPage,
      category: page.category)
    .subscribe(on: DispatchQueue.global(qos: .userInteractive))
    .eraseToAnyPublisher()
  }
}
