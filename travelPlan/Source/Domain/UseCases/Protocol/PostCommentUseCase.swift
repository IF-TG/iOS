//
//  PostCommentUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 3/23/24.
//

import Foundation
import Combine

protocol PostCommentUseCase {
  func sendComment(postId: PostIdentifier, comment: String) -> AnyPublisher<PostCommentEntity, Error>
  
  func updateComment(postId: PostIdentifier, commentId: CommentIdentifier, comment: String) -> AnyPublisher<Bool, Error>
  
  func deleteComment(postId: PostIdentifier, commentId: CommentIdentifier) -> AnyPublisher<Bool, Error>
  
  func fetchComments(with requestValue: PostCommentsRequestValue) -> AnyPublisher<[PostCommentEntity], Error>
}
