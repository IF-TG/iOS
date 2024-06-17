//
//  PostCommentRepository.swift
//  travelPlan
//
//  Created by 양승현 on 3/23/24.
//

import Combine

protocol PostCommentRepository {
  func sendComment(
    postId: PostIdentifier,
    comment: String
  ) -> AnyPublisher<PostCommentEntity, Error>
  
  func updateComment(
    postId: PostIdentifier?,
    commentId: CommentIdentifier,
    comment: String
  ) -> AnyPublisher<Bool, Error>
  
  func deleteComment(
    postId: PostIdentifier?, 
    commentId: CommentIdentifier
  ) -> AnyPublisher<Bool, Error>
  
  func fetchComments(
    page: Int32,
    perPage: Int32,
    postId: PostIdentifier
  ) -> AnyPublisher<[PostCommentEntity], Error>
  
  func toggleCommentHeart(
    postId: PostIdentifier?,
    commentId: CommentIdentifier
  ) -> AnyPublisher<ToggledPostCommentHeartEntity, Error>
}
