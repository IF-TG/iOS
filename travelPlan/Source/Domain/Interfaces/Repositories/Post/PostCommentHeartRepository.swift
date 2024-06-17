//
//  PostCommentHeartRepository.swift
//  travelPlan
//
//  Created by 양승현 on 5/6/24.
//

import Foundation
import Combine

protocol PostCommentHeartRepository {
  /// 댓글 좋아요한 사용자들 ID반환합니다.
  func fetchCommentHeartUsers(
    with postId: PostIdentifier,
    commentId: CommentIdentifier
  ) -> AnyPublisher<[UserIdentifier], Error>
  
  /// 댓글 좋아요한 개수 반환합니다.
  func fetchCommentHearts(
    with postId: PostIdentifier,
    commentId: CommentIdentifier
  ) -> AnyPublisher<Int, Error>
  
  /// 댓글 좋아요한 사용자 컬랙션에 추가합니다.
  func heartComment(
    with postId: PostIdentifier,
    commentId: CommentIdentifier,
    userId: UserIdentifier
  ) -> AnyPublisher<Void, Error>
  
  /// 댓글 좋아요한 사용자 컬랙션에서 해제합니다.
  func hateComment(
    with postId: PostIdentifier,
    commentId: CommentIdentifier,
    userId: UserIdentifier
  ) -> AnyPublisher<Void, Error>
  
  func updateCommentHearts(
    with postId: PostIdentifier,
    commentId: CommentIdentifier,
    userId: UserIdentifier,
    willHeartComment: Bool
  ) -> AnyPublisher<Void, Error>
}
