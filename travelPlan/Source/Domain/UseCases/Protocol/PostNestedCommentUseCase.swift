//
//  PostNestedCommentUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 3/27/24.
//

import Combine

protocol PostNestedCommentUseCase {
  func sendNestedComment(commentId: Int64, comment: String) -> AnyPublisher<PostNestedCommentEntity, Error>
  func updateNestedComment(nestedCommentId: Int64, comment: String) -> AnyPublisher<Bool, Error>
  func deleteNestedComment(nestedCommentId: Int64) -> AnyPublisher<Bool, Error>
}
