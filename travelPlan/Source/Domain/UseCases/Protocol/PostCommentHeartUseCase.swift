//
//  PostCommentHeartUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 5/6/24.
//

import Foundation
import Combine

protocol PostCommentHeartUseCase {
  func toggleCommentHeart(
    postId: PostIdentifier,
    commentId: CommentIdentifier
  ) -> AnyPublisher<ToggledPostCommentHeartEntity, Error>
}
