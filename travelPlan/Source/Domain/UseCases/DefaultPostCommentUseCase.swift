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
    return postCommentRepository
      .sendComment(postId: postId, comment: comment)
      .eraseToAnyPublisher()
  }
  
  func updateComment(commentId: Int64, comment: String) -> AnyPublisher<UpdatedPostCommentEntity, any Error> {
    return postCommentRepository
      .updateComment(commentId: commentId, comment: comment)
      .eraseToAnyPublisher()
  }
  
  func deleteComment(commentId: Int64) -> AnyPublisher<Bool, any Error> {
    return postCommentRepository
      .deleteComment(commentId: commentId)
      .eraseToAnyPublisher()
  }
}
