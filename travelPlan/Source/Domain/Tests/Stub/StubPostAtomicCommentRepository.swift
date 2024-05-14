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
final class StubPostAtomicCommentRepository: PostAtomicCommentRepository {
  private let createAt: Date = DateTimeConverter.toDate(from: "2024.5.14")!
  func fetchComments(
    postId: String
  ) -> AnyPublisher<[travelPlan.PostAtomicCommentEntity], any Error> {
    return Just([
      travelPlan.PostAtomicCommentEntity(
        commentId: "11",
        authorId: "11",
        comment: "댓1",
        createAt: createAt,
        hasDeleted: false,
        hearts: 0),
      travelPlan.PostAtomicCommentEntity(
        commentId: "22",
        authorId: "22",
        comment: "댓2",
        createAt: createAt,
        hasDeleted: false, hearts: 0)
    ]).setFailureType(to: (any Error).self)
      .eraseToAnyPublisher()
  }
  
  func sendComment(
    ownerId: String,
    postId: String,
    comment: String
  ) -> AnyPublisher<travelPlan.PostAtomicCommentEntity, any Error> {
    return Just(travelPlan.PostAtomicCommentEntity(
      commentId: "12",
      authorId: ownerId,
      comment: comment,
      createAt: createAt,
      hasDeleted: false,
      hearts: 0))
    .setFailureType(to: (any Error).self)
    .eraseToAnyPublisher()
  }
  
  func updateComment(
    postId: String,
    commentId: String,
    comment: String
  ) -> AnyPublisher<Void, any Error> {
    return Just(()).setFailureType(to: (any Error).self).eraseToAnyPublisher()
  }
  
  func deleteComment(
    hasAnyNestedCommentExisted: Bool,
    postId: String,
    commentId: String
  ) -> AnyPublisher<Void, any Error> {
    return Just(()).setFailureType(to: (any Error).self).eraseToAnyPublisher()
  }
}
