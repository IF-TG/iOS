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
    postId: PostIdentifier
  ) -> AnyPublisher<[PostAtomicCommentEntity], Error>
  
  func sendComment(
    ownerId: UserIdentifier,
    postId: PostIdentifier,
    comment: String
  ) -> AnyPublisher<PostAtomicCommentEntity, Error>
  
  func updateComment(
    postId: PostIdentifier,
    commentId: CommentIdentifier,
    comment: String
  ) -> AnyPublisher<Void, Error>
  
  func deleteComment(
    hasAnyNestedCommentExisted: Bool,
    postId: PostIdentifier,
    commentId: CommentIdentifier
  ) -> AnyPublisher<Void, Error>
}
