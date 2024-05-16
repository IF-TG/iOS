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
    with postId: String,
    commentId: String,
    nestedCommentId: String
  ) -> AnyPublisher<[UserIdentifier], any Error> {
    return Just(["111", "222"]).setAnyErrorAndEraseToAnyPublisher()
  }
  
  func fetchNestedCommentHearts(
    with postId: String,
    commentId: String,
    nestedCommentId: String
  ) -> AnyPublisher<Int, any Error> {
    return Just(2).setAnyErrorAndEraseToAnyPublisher()
  }
  
  func heartNestedComment(
    with postId: String,
    commentId: String,
    nestedCommentId: String,
    userId: String
  ) -> AnyPublisher<Void, any Error> {
    return Just(()).setAnyErrorAndEraseToAnyPublisher()
  }
  
  func hateNestedComment(
    with postId: String,
    commentId: String,
    nestedCommentId: String,
    userId: String
  ) -> AnyPublisher<Void, any Error> {
    return Just(()).setAnyErrorAndEraseToAnyPublisher()
  }
  
  func updateNestedCommentHearts(
    with postId: String,
    commentId: String,
    nestedCommentId: String,
    willHeartComment: Bool
  ) -> AnyPublisher<Void, any Error> {
    return Just(()).setAnyErrorAndEraseToAnyPublisher()
  }
}
