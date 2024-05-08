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
  ) -> AnyPublisher<PostAtomicNestedCommentEntity, Error>
  
  func updateNestedComment(
    postId: String,
    commentId: String,
    nestedCommentId: String,
    comment: String
  ) -> AnyPublisher<Void, Error>
  
  func deleteNestedComment(
    postId: String,
    commentId: String,
    nestedCommentId: String
  ) -> AnyPublisher<Void, Error>
}
