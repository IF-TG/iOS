//
//  DefaultPostUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 3/8/24.
//

import Foundation
import Combine
import Foundation

final class DefaultPostUseCase: PostUseCase {
  // MARK: - Dependencies
  private let postRepository: PostRepository
  
  private let backgroundQueue: DispatchQueue

  // MARK: - Lifecycle
  init(postRepository: PostRepository, backgroundQueue: DispatchQueue = .global(qos: .default)) {
    self.postRepository = postRepository
    self.backgroundQueue = backgroundQueue
  }
  
  func fetchPosts(with page: PostFetchRequestValue) -> AnyPublisher<[PostContainer], any Error> {
    return postRepository.fetchPosts(
      page: page.page,
      perPage: page.perPage,
      category: page.category)
    .subscribe(on: DispatchQueue.global(qos: .userInteractive))
    .eraseToAnyPublisher()
  }
  
  func fetchComments(
    with requestValue: PostCommentsRequestValue
  ) -> AnyPublisher<PostCommentContainerEntity, any Error> {
    postRepository.fetchComments(
      page: requestValue.page,
      perPage: requestValue.perPage,
      postId: requestValue.postId)
    .subscribe(on: backgroundQueue)
    .eraseToAnyPublisher()
  }
}
