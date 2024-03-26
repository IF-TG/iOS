//
//  PostCommentRepository.swift
//  travelPlan
//
//  Created by 양승현 on 3/23/24.
//

import Combine

protocol PostCommentRepository {
  func sendComment(postId: Int64, comment: String) -> Future<PostCommentEntity, Error>
  
  func updateComment(commentId: Int64, comment: String) -> Future<UpdatedPostCommentEntity, Error>
  
  func deleteComment(commentId: Int64) -> Future<Bool, Error>
}
