//
//  PostCommentUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 3/23/24.
//

import Foundation
import Combine

protocol PostCommentUseCase {
  func sendComment(postId: Int64, comment: String) -> AnyPublisher<PostCommentEntity, Error>
  
  func updateComment(commentId: Int64, comment: String) -> AnyPublisher<UpdatedPostCommentEntity, Error>
  
  func deleteComment(commentId: Int64) -> AnyPublisher<Bool, Error>
  
  func fetchComments(with requestValue: PostCommentsRequestValue) -> AnyPublisher<PostCommentEntity, Error>
}
