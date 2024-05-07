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
    postId: String,
    commentId: String
  ) -> AnyPublisher<[PostAtomicNestedCommentEntity], Error>
  
  func sendNestedComment(
    ownerId: String,
    postId: String,
    commentId: String,
    comment: String
  ) -> AnyPublisher<[PostAtomicNestedCommentEntity], Error>
  
  func updateNestedComment(
    ownerId: String,
    postId: String,
    commentId: String
  ) -> AnyPublisher<[PostAtomicNestedCommentEntity], Error>
  
  /// 댓글이 삭제됬는지 고려해야 합니다.
  func deleteNestedComment(
    hasCommentDeleted: Bool,
    postId: String,
    commentId: String,
    nestedCommentId: String
  ) -> AnyPublisher<Void, Error>
}
