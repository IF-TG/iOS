//
//  PostNestedCommentHeartUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 5/13/24.
//

import Foundation
import Combine

protocol PostNestedCommentHeartUseCase {
  func toggleNestedCommentHeart(
    postId: PostIdentifier,
    commentId: CommentIdentifier,
    nestedCommentId: NestedCommentIdentifier
  ) -> AnyPublisher<ToggledPostCommentHeartEntity, any Error>
}
