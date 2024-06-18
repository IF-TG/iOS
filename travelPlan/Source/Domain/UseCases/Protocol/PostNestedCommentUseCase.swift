//
//  PostNestedCommentUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 3/27/24.
//

import Combine

protocol PostNestedCommentUseCase {
  func sendNestedComment(
    postId: PostIdentifier,
    commentId: CommentIdentifier,
    comment: String
  ) -> AnyPublisher<PostNestedCommentEntity, Error>
  func updateNestedComment(
    postId: PostIdentifier,
    commentId: CommentIdentifier,
    nestedCommentId: NestedCommentIdentifier,
    comment: String
  ) -> AnyPublisher<Bool, Error>
  func deleteNestedComment(
    postId: PostIdentifier,
    commentId: CommentIdentifier,
    nestedCommentId: NestedCommentIdentifier,
    hasDeletedComment: Bool
  ) -> AnyPublisher<DeletedNestedCommentResult, Error>
}
