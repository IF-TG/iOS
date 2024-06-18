//
//  DefaultPostNestedCommentHeartUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 5/13/24.
//

import Foundation
import Combine

final class DefaultPostNestedCommentHeartUseCase {
  // MARK: - Dependencies
  private let postNestedCommentRepository: PostNestedCommentRepository
  
  // MARK: - Lifecycle
  init(postNestedCommentRepository: PostNestedCommentRepository) {
    self.postNestedCommentRepository = postNestedCommentRepository
  }
}

// MARK: - PostNestedCommentHeartUseCase
extension DefaultPostNestedCommentHeartUseCase: PostNestedCommentHeartUseCase {
  func toggleNestedCommentHeart(
    postId: PostIdentifier,
    commentId: CommentIdentifier,
    nestedCommentId: NestedCommentIdentifier
  ) -> AnyPublisher<ToggledPostCommentHeartEntity, any Error> {
    return postNestedCommentRepository
      .toggleCommentHeart(nestedCommentId: nestedCommentId)
  }
}
