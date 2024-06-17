//
//  PostNestedCommentRepository.swift
//  travelPlan
//
//  Created by 양승현 on 3/27/24.
//

import Combine

protocol PostNestedCommentRepository {
  func sendNestedComment(commentId: CommentIdentifier, comment: String) -> AnyPublisher<PostNestedCommentEntity, Error>
  func updateNestedComment(nestedCommentId: NestedCommentIdentifier, comment: String) -> AnyPublisher<Bool, Error>
  // MARK: 대댓글이 제거되면, 댓글이 제거되었는지 여부도 알수 있으면 좋습니다.
  // 이는 그냥 서버에서 받아온 댓글이 마지막일 경우 삭제되도록 의논 완료.
  func deleteNestedComment(nestedCommentId: NestedCommentIdentifier) -> AnyPublisher<DeletedNestedCommentResult, Error>
  func toggleCommentHeart(nestedCommentId: NestedCommentIdentifier) -> AnyPublisher<ToggledPostCommentHeartEntity, Error>
}
