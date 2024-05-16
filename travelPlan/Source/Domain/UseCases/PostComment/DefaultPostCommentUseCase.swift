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
  
  func sendComment(postId: String, comment: String) -> AnyPublisher<PostCommentEntity, any Error> {
    return postCommentRepository
      .sendComment(postId: postId, comment: comment)
      .eraseToAnyPublisher()
  }
  
  func updateComment(postId: String, commentId: String, comment: String) -> AnyPublisher<Bool, any Error> {
    return postCommentRepository
      .updateComment(postId: nil, commentId: commentId, comment: comment)
      .eraseToAnyPublisher()
  }
  
  func deleteComment(postId: String, commentId: String) -> AnyPublisher<Bool, any Error> {
    return postCommentRepository
      .deleteComment(postId: postId, commentId: commentId)
      .eraseToAnyPublisher()
  }
  
  func fetchComments(with requestValue: PostCommentsRequestValue) -> AnyPublisher<[PostCommentEntity], any Error> {
    return postCommentRepository
      .fetchComments(page: requestValue.page, perPage: requestValue.perPage, postId: requestValue.postId)
      .eraseToAnyPublisher()
  }
}
