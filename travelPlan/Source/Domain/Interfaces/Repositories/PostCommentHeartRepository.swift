//
//  PostCommentHeartRepository.swift
//  travelPlan
//
//  Created by 양승현 on 5/6/24.
//

import Foundation
import Combine

protocol PostCommentHeartRepository {
  typealias UserIdentifier = String
  
  /// 댓글 좋아요한 사용자들 ID반환합니다.
  func fetchCommentHeartUsers(
    with postId: String,
    commentId: String
  ) -> AnyPublisher<[UserIdentifier], Error>
  
  /// 댓글 좋아요한 개수 반환합니다.
  func fetchCommentHearts(
    with postId: String,
    commentId: String
  ) -> AnyPublisher<Int, Error>
  
  /// 댓글 좋아요한 사용자 컬랙션에 추가합니다.
  func heartComment(
    with postId: String,
    commentId: String,
    userId: String
  ) -> AnyPublisher<Void, Error>
  
  /// 댓글 좋아요한 사용자 컬랙션에서 해제합니다.
  func hateComment(
    with postId: String,
    commentId: String,
    userId: String
  ) -> AnyPublisher<Void, Error>
  
  func updatePostHearts(
    with postId: String,
    commentId: String,
    userId: String,
    willHeartComment: Bool) -> AnyPublisher<Void, Error>
}
