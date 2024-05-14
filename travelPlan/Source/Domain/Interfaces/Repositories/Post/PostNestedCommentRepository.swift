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
  // MARK: 대댓글이 제거되면, 댓글이 제거되었는지 여부도 알수 있으면 좋습니다.
  func deleteNestedComment(nestedCommentId: String) -> AnyPublisher<DeletedNestedCommentResult, Error>
  func toggleCommentHeart(nestedCommentId: String) -> AnyPublisher<ToggledPostCommentHeartEntity, Error>
}
