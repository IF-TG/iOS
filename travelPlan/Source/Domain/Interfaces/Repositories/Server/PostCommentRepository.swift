//
//  PostCommentRepository.swift
//  travelPlan
//
//  Created by 양승현 on 3/23/24.
//

import Combine

protocol PostCommentRepository {
  func sendComment(postId: String, comment: String) -> AnyPublisher<PostCommentEntity, Error>
  
  func updateComment(commentId: String, comment: String) -> AnyPublisher<Bool, Error>
  
  func deleteComment(commentId: String) -> AnyPublisher<Bool, Error>
  
  func fetchComments(page: Int32, perPage: Int32, postId: String) -> AnyPublisher<[PostCommentEntity], Error>
  
  func toggleCommentHeart(commentId: String) -> AnyPublisher<ToggledPostCommentHeartEntity, Error>
}
