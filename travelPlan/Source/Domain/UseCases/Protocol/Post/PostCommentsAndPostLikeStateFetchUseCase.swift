//
//  PostCommentsAndPostLikeStateFetchUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 5/15/24.
//

import Foundation
import Combine

protocol PostCommentsAndPostLikeStateFetchUseCase {
  func fetchCommentsAndPostLikeStatus(
    with requestValue: PostCommentsRequestValue
  ) -> AnyPublisher<PostCommentContainerEntity, Error>
}
