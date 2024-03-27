//
//  DefaultPostNestedCommentUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 3/27/24.
//

import Combine

final class DefaultPostNestedCommentUseCase: PostNestedCommentUseCase {
  // MARK: - Dependencies
  private let postNestedCommentRepository: PostNestedCommentRepository
  
  // MARK: - Lifecycle
  init(postNestedCommentRepository: PostNestedCommentRepository) {
    self.postNestedCommentRepository = postNestedCommentRepository
  }
  
  // MARK: - helpers
  func sendNestedComment(
    commentId: Int64,
    comment: String
  ) -> AnyPublisher<PostNestedCommentEntity, any Error> {
    return postNestedCommentRepository
      .sendNestedComment(commentId: commentId, comment: comment)
      .eraseToAnyPublisher()
  }
  
  func updateNestedComment(
    nestedCommentId: Int64,
    comment: String
  ) -> AnyPublisher<Bool, any Error> {
    return postNestedCommentRepository
      .updateNestedComment(nestedCommentId: nestedCommentId, comment: comment)
      .eraseToAnyPublisher()
  }
}
