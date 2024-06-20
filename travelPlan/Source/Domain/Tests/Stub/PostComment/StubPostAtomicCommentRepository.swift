//
//  StubPostAtomicCommentRepository.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/14/24.
//

import Foundation
import Combine
@testable import travelPlan

/// 모든 함수는 항상 옳은 값을 반환합니다.
struct StubPostAtomicCommentRepository: PostAtomicCommentRepository {
  private let createAt: Date = DateTimeConverter.toDate(from: "2024.5.14")!
  func fetchComments(
    postId: PostIdentifier
  ) -> AnyPublisher<[travelPlan.PostAtomicCommentEntity], any Error> {
    return Just([
      travelPlan.PostAtomicCommentEntity(
        commentId: 11,
        authorId: 11,
        comment: "댓1",
        createAt: createAt,
        hasDeleted: false,
        hearts: 0),
      travelPlan.PostAtomicCommentEntity(
        commentId: 22,
        authorId: 22,
        comment: "댓2",
        createAt: createAt,
        hasDeleted: false, hearts: 0)
    ]).setAnyErrorAndEraseToAnyPublisher()
  }
  
  func sendComment(
    ownerId: UserIdentifier,
    postId: PostIdentifier,
    comment: String
  ) -> AnyPublisher<travelPlan.PostAtomicCommentEntity, any Error> {
    return Just(travelPlan.PostAtomicCommentEntity(
      commentId: 12,
      authorId: ownerId,
      comment: comment,
      createAt: createAt,
      hasDeleted: false,
      hearts: 0))
    .setAnyErrorAndEraseToAnyPublisher()
  }
  
  func updateComment(
    postId: PostIdentifier,
    commentId: CommentIdentifier,
    comment: String
  ) -> AnyPublisher<Void, any Error> {
    return Just(()).setAnyErrorAndEraseToAnyPublisher()
  }
  
  func deleteComment(
    hasAnyNestedCommentExisted: Bool,
    postId: PostIdentifier,
    commentId: CommentIdentifier
  ) -> AnyPublisher<Void, any Error> {
    return Just(()).setAnyErrorAndEraseToAnyPublisher()
  }
}
