//
//  StubPostCommentHeartRepository.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/14/24.
//

import Foundation
import Combine
@testable import travelPlan

struct StubPostCommentHeartRepository: PostCommentHeartRepository {
  func fetchCommentHeartUsers(
    with postId: String,
    commentId: String
  ) -> AnyPublisher<[UserIdentifier], any Error> {
    Just(["userId1234", "userId1235"]).setAnyErrorAndEraseToAnyPublisher()
  }
  
  func fetchCommentHearts(
    with postId: String,
    commentId: String
  ) -> AnyPublisher<Int, any Error> {
    Just(2).setAnyErrorAndEraseToAnyPublisher()
  }
  
  func heartComment(
    with postId: String,
    commentId: String,
    userId: String
  ) -> AnyPublisher<Void, any Error> {
    Just(()).setAnyErrorAndEraseToAnyPublisher()
  }
  
  func hateComment(
    with postId: String,
    commentId: String,
    userId: String
  ) -> AnyPublisher<Void, any Error> {
    Just(()).setAnyErrorAndEraseToAnyPublisher()
  }
  
  func updateCommentHearts(
    with postId: String,
    commentId: String,
    userId: String,
    willHeartComment: Bool
  ) -> AnyPublisher<Void, any Error> {
    Just(()).setAnyErrorAndEraseToAnyPublisher()
  }
}
