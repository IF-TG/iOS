//
//  PostCommentAtomicRepository.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/5/24.
//

import Foundation
import Combine
 
protocol PostAtomicCommentRepository {
  func fetchComments(
    postId: String
  ) -> AnyPublisher<[PostAtomicCommentEntity], Error>
  
  func sendComment(
    ownerId: String,
    postId: String,
    comment: String
  ) -> AnyPublisher<PostAtomicCommentEntity, Error>
  
  func updateComment(
    postId: String,
    commentId: String,
    comment: String
  ) -> AnyPublisher<Void, Error>
  
  func deleteComment(
    hasAnyNestedCommentExisted: Bool,
    postId: String,
    commentId: String
  ) -> AnyPublisher<Void, Error>
}
