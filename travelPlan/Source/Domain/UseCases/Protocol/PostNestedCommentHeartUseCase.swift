//
//  PostNestedCommentHeartUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 5/13/24.
//

import Foundation

protocol PostNestedCommentHeartUseCase {
  func toggleNestedCommentHeart(
    postId: String,
    commentId: String,
    nestedCommentId: String
  ) -> AnyPublisher<ToggledPostCommentHeartEntity, Error>
  
  
}
