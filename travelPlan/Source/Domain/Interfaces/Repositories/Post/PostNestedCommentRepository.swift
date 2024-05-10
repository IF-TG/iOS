//
//  PostNestedCommentRepository.swift
//  travelPlan
//
//  Created by 양승현 on 3/27/24.
//

import Combine

protocol PostNestedCommentRepository {
  func sendNestedComment(commentId: String, comment: String) -> AnyPublisher<PostNestedCommentEntity, Error>
  func updateNestedComment(nestedCommentId: String, comment: String) -> AnyPublisher<Bool, Error>
  func deleteNestedComment(nestedCommentId: String) -> AnyPublisher<Bool, Error>
  func toggleCommentHeart(nestedCommentId: String) -> AnyPublisher<ToggledPostCommentHeartEntity, Error>
}
