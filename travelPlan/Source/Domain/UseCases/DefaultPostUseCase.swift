//
//  DefaultPostUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 3/8/24.
//

import Combine
import Foundation

final class DefaultPostUseCase: PostUseCase {
  // MARK: - Dependencies
  private let postRepository: PostRepository
  
  private let backgroundQueue: DispatchQueue
  
  // MARK: - Properties
  var postContainers = PassthroughSubject<[PostContainer], MainError>()
  
  private var subscriptions = Set<AnyCancellable>()
  
  // MARK: - Lifecycle
  init(postRepository: PostRepository, backgroundQueue: DispatchQueue = .global(qos: .default)) {
    self.postRepository = postRepository
    self.backgroundQueue = backgroundQueue
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
  
  func fetchComments(
    with requestValue: PostCommentsReqeustValue
  ) -> AnyPublisher<PostCommentContainerEntity, any Error> {
    postRepository.fetchComments(
      page: requestValue.page,
      perPage: requestValue.perPage,
      postId: requestValue.postId)
    .subscribe(on: backgroundQueue)
    .eraseToAnyPublisher()
  }
}
