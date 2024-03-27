//
//  PostNestedCommentRepository.swift
//  travelPlan
//
//  Created by 양승현 on 3/27/24.
//

import Combine

protocol PostNestedCommentRepository {
  func sendNestedComment(commentId: Int64, comment: String) -> Future<PostNestedCommentEntity, Error>
  func updateNestedComment(nestedCommentId: Int64, comment: String) -> Future<Bool, Error>
}
