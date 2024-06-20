//
//  StubPostAtomicNestedCommentRepository.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/14/24.
//

import Foundation
import Combine
@testable import travelPlan

/// 모든 함수는 항상 옳은 값을 반환합니다.
struct StubPostAtomicNestedCommentRepository: PostAtomicNestedCommentRepository {
  private let createAt: Date = DateTimeConverter.toDate(from: "2024.5.14")!
  
  func fetchNestedComments(
    postId: PostIdentifier,
    commentId: CommentIdentifier
  ) -> AnyPublisher<[travelPlan.PostAtomicNestedCommentEntity], any Error> {
    Just([
      PostAtomicNestedCommentEntity(
        nestedCommentId: Int64.random(in: 1000...7777),
        authorId: 1,
        comment: "야호!!",
        createAt: createAt,
        hearts: 0),
      PostAtomicNestedCommentEntity(
        nestedCommentId: Int64.random(in: 1000...7777),
        authorId: 2,
        comment: "야호!!",
        createAt: createAt,
        hearts: 0),
      PostAtomicNestedCommentEntity(
        nestedCommentId: Int64.random(in: 1000...7777),
        authorId: 3,
        comment: "야호!!",
        createAt: createAt,
        hearts: 0)
    ]).setAnyErrorAndEraseToAnyPublisher()
  }
  
  func fetchTheNumberOfNestedComments(
    postId: PostIdentifier,
    commentId: CommentIdentifier
  ) -> AnyPublisher<Int, any Error> {
    Just(2).setAnyErrorAndEraseToAnyPublisher()
  }
  
  func sendNestedComment(
    ownerId: CommentIdentifier,
    postId: PostIdentifier,
    commentId: CommentIdentifier,
    comment: String
  ) -> AnyPublisher<travelPlan.PostAtomicNestedCommentEntity, any Error> {
    return Just(PostAtomicNestedCommentEntity(
      nestedCommentId: 1111,
      authorId: 1231,
      comment: comment,
      createAt: createAt,
      hearts: 0))
    .setAnyErrorAndEraseToAnyPublisher()
  }
  
  func updateNestedComment(
    postId: PostIdentifier,
    commentId: CommentIdentifier,
    nestedCommentId: NestedCommentIdentifier,
    comment: String
  ) -> AnyPublisher<Void, any Error> {
    return Just(()).setAnyErrorAndEraseToAnyPublisher()
  }
  
  func deleteNestedComment(
    postId: PostIdentifier,
    commentId: CommentIdentifier,
    nestedCommentId: NestedCommentIdentifier
  ) -> AnyPublisher<Void, any Error> {
    return Just(()).setAnyErrorAndEraseToAnyPublisher()
  }
  
  func deleteAllNestedComments(
    postId: PostIdentifier,
    commentId: CommentIdentifier
  ) -> AnyPublisher<Void, any Error> {
    return Just(()).setAnyErrorAndEraseToAnyPublisher()
  }
}
