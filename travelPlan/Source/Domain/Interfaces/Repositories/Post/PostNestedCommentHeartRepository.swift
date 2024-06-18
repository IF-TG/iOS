//
//  PostNestedCommentHeartRepository.swift
//  travelPlan
//
//  Created by 양승현 on 5/10/24.
//

import Combine
import Foundation

protocol PostNestedCommentHeartRepository {
  /// 대댓글 좋아요한 사용자들 ID반환합니다.
  func fetchNestedCommentHeartUsers(
    with postId: PostIdentifier,
    commentId: CommentIdentifier,
    nestedCommentId: NestedCommentIdentifier
  ) -> AnyPublisher<[UserIdentifier], Error>
  
  /// 대댓글 좋아요한 개수 반환합니다.
  func fetchNestedCommentHearts(
    with postId: PostIdentifier,
    commentId: CommentIdentifier,
    nestedCommentId: NestedCommentIdentifier
  ) -> AnyPublisher<Int, Error>
  
  /// 대댓글 좋아요한 사용자 컬랙션에 추가합니다.
  func heartNestedComment(
    with postId: PostIdentifier,
    commentId: CommentIdentifier,
    nestedCommentId: NestedCommentIdentifier,
    userId: UserIdentifier
  ) -> AnyPublisher<Void, Error>
  
  /// 대댓글 좋아요한 사용자 컬랙션에서 해제합니다.
  func hateNestedComment(
    with postId: PostIdentifier,
    commentId: CommentIdentifier,
    nestedCommentId: NestedCommentIdentifier,
    userId: UserIdentifier
  ) -> AnyPublisher<Void, Error>
  
  /// 대댓글 필드에 hearts 개수를 1 증가 또는 1 감소시킵니다.
  func updateNestedCommentHearts(
    with postId: PostIdentifier,
    commentId: CommentIdentifier,
    nestedCommentId: NestedCommentIdentifier,
    willHeartComment: Bool
  ) -> AnyPublisher<Void, Error>
}
