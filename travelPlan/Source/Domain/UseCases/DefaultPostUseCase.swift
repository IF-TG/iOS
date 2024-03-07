//
//  DefaultPostUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 3/8/24.
//

import Combine

final class DefaultPostUseCase: PostUseCase {
  // MARK: - Dependencies
  private let postRepository: PostRepository
  
  // MARK: - Properties
  var postContainers = PassthroughSubject<[PostContainer], MainError>()
  
  private var subscriptions = Set<AnyCancellable>()
  
  // MARK: - Lifecycle
  init(postRepository: PostRepository) {
    self.postRepository = postRepository
  }
  
  func fetchPosts(with page: PostsPage) {
    postRepository.fetchPosts(with: page)
      .sink { [weak self] completion in
        if case .failure(let error) = completion {
          self?.postContainers.send(completion: .failure(error))
        }
      } receiveValue: { [weak self] result in
        self?.postContainers.send(result)
      }.store(in: &subscriptions)
  }
}
