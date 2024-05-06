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
    _ postId: String,
    _ commentId: String
  ) -> AnyPublisher<[UserIdentifier], Error>
  
  /// 댓글 좋아요한 개수 반환합니다.
  func fetchCommentHearts(
    _ postId: String,
    _ commentId: String
  ) -> AnyPublisher<Int, Error>
  
  /// 댓글 좋아요한 사용자 컬랙션에 추가합니다.
  func heartComment(
    _ postId: String,
    commentId: String,
    userId: String
  ) -> AnyPublisher<Void, Error>
  
  /// 댓글 좋아요한 사용자 컬랙션에서 해제합니다.
  func hateComment(
    _ postId: String,
    commentId: String,
    userId: String
  ) -> AnyPublisher<Void, Error>
  
  func togglePostHearts(
    _ postId: String,
    commentId: String,
    userId: String,
    willHeartComment: Bool) -> AnyPublisher<Void, Error>
}
