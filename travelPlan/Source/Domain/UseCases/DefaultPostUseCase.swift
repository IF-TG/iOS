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
  
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable>()
  
  // MARK: - Lifecycle
  init(postRepository: PostRepository) {
    self.postRepository = postRepository
  }
  
  func fetchPosts(with page: PostsPage) -> AnyPublisher<[PostContainer], any Error> {
    postRepository.fetchPosts(with: page)
      .subscribe(on: DispatchQueue.global(qos: .userInteractive))
      .mapError { $0 }
      .eraseToAnyPublisher()
  }
}
