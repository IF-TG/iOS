//
//  DefaultPostCommentHeartUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 5/6/24.
//

import Foundation
import Combine

final class DefaultPostCommentHeartUseCase: PostCommentHeartUseCase {
  // MARK: - Dependencies
  private let postCommentRepository: PostCommentRepository
  
  // MARK: - Lifecycle
  init(postCommentRepository: PostCommentRepository) {
    self.postCommentRepository = postCommentRepository
  }
  
  func toggleCommentHeart(
    postId: String,
    commentId: String
  ) -> AnyPublisher<ToggledPostCommentHeartEntity, any Error> {
    return postCommentRepository
      .toggleCommentHeart(commentId: commentId)
      .eraseToAnyPublisher()
  }
}
