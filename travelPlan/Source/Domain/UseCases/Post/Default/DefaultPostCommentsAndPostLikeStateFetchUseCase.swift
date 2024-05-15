//
//  DefaultPostCommentsAndPostLikeStateFetchUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 5/16/24.
//

import Combine
import Foundation

final class DefaultPostCommentsAndPostLikeStateFetchUseCase: PostCommentsAndPostLikeStateFetchUseCase {
  // MARK: - Dependencies
  private let postRepository: PostRepository
  
  private let backgroundQueue: DispatchQueue
  
  // MARK: - Lifecycle
  init(postRepository: PostRepository, backgroundQueue: DispatchQueue = .global(qos: .default)) {
    self.postRepository = postRepository
    self.backgroundQueue = backgroundQueue
  }
  
  func fetchCommentsAndPostLikeStatus(
    with requestValue: PostCommentsRequestValue
  ) -> AnyPublisher<PostCommentContainerEntity, any Error> {
    return postRepository.fetchComments(
      page: requestValue.page,
      perPage: requestValue.perPage,
      postId: requestValue.postId)
  }
}
