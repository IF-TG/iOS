//
//  PostNestedCommentUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 3/27/24.
//

import Combine

protocol PostNestedCommentUseCase {
  func sendNestedComment(
    postId: String,
    commentId: String,
    comment: String
  ) -> AnyPublisher<PostNestedCommentEntity, Error>
  func updateNestedComment(
    postId: String,
    commentId: String,
    nestedCommentId: String,
    comment: String
  ) -> AnyPublisher<Bool, Error>
  func deleteNestedComment(
    postId: String,
    commentId: String,
    nestedCommentId: String,
    hasDeletedComment: Bool
  ) -> AnyPublisher<Bool, Error>
}
