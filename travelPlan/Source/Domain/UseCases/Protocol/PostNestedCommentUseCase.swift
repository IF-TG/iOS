//
//  PostNestedCommentUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 3/27/24.
//

import Combine

protocol PostNestedCommentUseCase {
  func sendNestedComment(
    commentId: String,
    comment: String
  ) -> AnyPublisher<PostNestedCommentEntity, Error>
  func updateNestedComment(
    nestedCommentId: String,
    comment: String
  ) -> AnyPublisher<Bool, Error>
  // 대댓글을 삭제할때 댓글이 제거됬다면 댓글 제거후 이 함수 동시 호출하도록 하는게좋을것같습니다.
  func deleteNestedComment(
    nestedCommentId: String
  ) -> AnyPublisher<Bool, Error>
}
