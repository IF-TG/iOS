//
//  PostAtomicNestedCommentRepository.swift
//  travelPlan
//
//  Created by 양승현 on 5/7/24.
//

import Foundation
import Combine

protocol PostAtomicNestedCommentRepository {
  func fetchNestedComments(
    postId: PostIdentifier,
    commentId: CommentIdentifier
  ) -> AnyPublisher<[PostAtomicNestedCommentEntity], Error>
  
  func fetchTheNumberOfNestedComments(
    postId: PostIdentifier,
    commentId: CommentIdentifier
  ) -> AnyPublisher<Int, Error>
  
  func sendNestedComment(
    ownerId: UserIdentifier,
    postId: PostIdentifier,
    commentId: CommentIdentifier,
    comment: String
  ) -> AnyPublisher<PostAtomicNestedCommentEntity, Error>
  
  func updateNestedComment(
    postId: PostIdentifier,
    commentId: CommentIdentifier,
    nestedCommentId: NestedCommentIdentifier,
    comment: String
  ) -> AnyPublisher<Void, Error>
  
  /// 대댓글 제거할때 대댓글 전부 제거됬고, 댓글도 제거됬으면 트랜젝선으로 댓 삭, 대댓 삭 둘다 처리해야하는데.
  /// 삭제된 댓글에서 대댓글을 제거할 경우에, 더이상 대댓글이 달리지 않기 때문에 트랜젝션을 꼭 안써도 된다.
  func deleteNestedComment(
    postId: PostIdentifier,
    commentId: CommentIdentifier,
    nestedCommentId: NestedCommentIdentifier
  ) -> AnyPublisher<Void, Error>
  
  func deleteAllNestedComments(
    postId: PostIdentifier,
    commentId: CommentIdentifier
  ) -> AnyPublisher<Void, Error>
}
