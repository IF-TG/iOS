//
//  StubPostNestedCommentHeartRepository.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/14/24.
//

import Foundation
import Combine
@testable import travelPlan

struct StubPostNestedCommentHeartRepository: PostNestedCommentHeartRepository {
  func fetchNestedCommentHeartUsers(
    with postId: PostIdentifier,
    commentId: CommentIdentifier,
    nestedCommentId: NestedCommentIdentifier
  ) -> AnyPublisher<[UserIdentifier], any Error> {
    return Just([111, 222]).setAnyErrorAndEraseToAnyPublisher()
  }
  
  func fetchNestedCommentHearts(
    with postId: PostIdentifier,
    commentId: CommentIdentifier,
    nestedCommentId: NestedCommentIdentifier
  ) -> AnyPublisher<Int, any Error> {
    return Just(2).setAnyErrorAndEraseToAnyPublisher()
  }
  
  func heartNestedComment(
    with postId: PostIdentifier,
    commentId: CommentIdentifier,
    nestedCommentId: NestedCommentIdentifier,
    userId: UserIdentifier
  ) -> AnyPublisher<Void, any Error> {
    return Just(()).setAnyErrorAndEraseToAnyPublisher()
  }
  
  func hateNestedComment(
    with postId: PostIdentifier,
    commentId: CommentIdentifier,
    nestedCommentId: NestedCommentIdentifier,
    userId: UserIdentifier
  ) -> AnyPublisher<Void, any Error> {
    return Just(()).setAnyErrorAndEraseToAnyPublisher()
  }
  
  func updateNestedCommentHearts(
    with postId: PostIdentifier,
    commentId: CommentIdentifier,
    nestedCommentId: NestedCommentIdentifier,
    willHeartComment: Bool
  ) -> AnyPublisher<Void, any Error> {
    return Just(()).setAnyErrorAndEraseToAnyPublisher()
  }
}
