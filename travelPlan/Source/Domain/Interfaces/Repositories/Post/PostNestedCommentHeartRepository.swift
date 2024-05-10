//
//  PostNestedCommentHeartRepository.swift
//  travelPlan
//
//  Created by 양승현 on 5/10/24.
//

import Combine
import Foundation

protocol PostNestedCommentHeartRepository {
  typealias UserIdentifier = String
  
  /// 대댓글 좋아요한 사용자들 ID반환합니다.
  func fetchNestedCommentHeartUsers(
    with postId: String,
    commentId: String
  ) -> AnyPublisher<[UserIdentifier], Error>
  
  /// 대댓글 좋아요한 개수 반환합니다.
  func fetchNestedCommentHearts(
    with postId: String,
    commentId: String
  ) -> AnyPublisher<Int, Error>
  
  /// 대댓글 좋아요한 사용자 컬랙션에 추가합니다.
  func heartNestedComment(
    with postId: String,
    commentId: String,
    userId: String
  ) -> AnyPublisher<Void, Error>
  
  /// 대댓글 좋아요한 사용자 컬랙션에서 해제합니다.
  func hateNestedComment(
    with postId: String,
    commentId: String,
    userId: String
  ) -> AnyPublisher<Void, Error>
  
  /// 대댓글 필드에 hearts 개수를 1 증가 또는 1 감소시킵니다.
  func updateNestedCommentHearts(
    with postId: String,
    commentId: String,
    userId: String,
    willHeartComment: Bool) -> AnyPublisher<Void, Error>
}
