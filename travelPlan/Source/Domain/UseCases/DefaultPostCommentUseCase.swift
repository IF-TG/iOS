//
//  DefaultPostCommentUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 3/23/24.
//

import Foundation
import Combine

final class DefaultPostCommentUseCase: PostCommentUseCase {
  // MARK: - Dependencies
  private let postCommentRepository: PostCommentRepository
  
  // MARK: - Lifecycle
  init(postCommentRepository: PostCommentRepository) {
    self.postCommentRepository = postCommentRepository
  }
  
  func sendComment(postId: Int64, comment: String) -> AnyPublisher<PostCommentEntity, any Error> {
    postCommentRepository.sendComment(postId: postId, comment: comment)
      .eraseToAnyPublisher()
  }
}
