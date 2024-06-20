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
    with postId: PostIdentifier,
    commentId: CommentIdentifier
  ) -> AnyPublisher<[UserIdentifier], any Error> {
    Just([11, 22]).setAnyErrorAndEraseToAnyPublisher()
  }
  
  func fetchCommentHearts(
    with postId: PostIdentifier,
    commentId: CommentIdentifier
  ) -> AnyPublisher<Int, any Error> {
    Just(2).setAnyErrorAndEraseToAnyPublisher()
  }
  
  func heartComment(
    with postId: PostIdentifier,
    commentId: CommentIdentifier,
    userId: UserIdentifier
  ) -> AnyPublisher<Void, any Error> {
    Just(()).setAnyErrorAndEraseToAnyPublisher()
  }
  
  func hateComment(
    with postId: PostIdentifier,
    commentId: CommentIdentifier,
    userId: UserIdentifier
  ) -> AnyPublisher<Void, any Error> {
    Just(()).setAnyErrorAndEraseToAnyPublisher()
  }
  
  func updateCommentHearts(
    with postId: PostIdentifier,
    commentId: CommentIdentifier,
    userId: UserIdentifier,
    willHeartComment: Bool
  ) -> AnyPublisher<Void, any Error> {
    Just(()).setAnyErrorAndEraseToAnyPublisher()
  }
}
