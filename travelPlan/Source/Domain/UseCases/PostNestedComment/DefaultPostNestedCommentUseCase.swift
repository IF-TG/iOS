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
    postId: PostIdentifier,
    commentId: CommentIdentifier,
    comment: String
  ) -> AnyPublisher<PostNestedCommentEntity, any Error> {
    return postNestedCommentRepository.sendNestedComment(commentId: commentId, comment: comment)
  }
  
  func updateNestedComment(
    postId: PostIdentifier,
    commentId: CommentIdentifier,
    nestedCommentId: NestedCommentIdentifier,
    comment: String
  ) -> AnyPublisher<Bool, any Error> {
    return postNestedCommentRepository.updateNestedComment(nestedCommentId: nestedCommentId, comment: comment)
  }
  
  func deleteNestedComment(
    postId: PostIdentifier,
    commentId: CommentIdentifier,
    nestedCommentId: NestedCommentIdentifier,
    hasDeletedComment: Bool
  ) -> AnyPublisher<DeletedNestedCommentResult, any Error> {
    return postNestedCommentRepository.deleteNestedComment(nestedCommentId: nestedCommentId)
  }
}
