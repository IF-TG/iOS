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
    postId: String,
    commentId: String
  ) -> AnyPublisher<[travelPlan.PostAtomicNestedCommentEntity], any Error> {
    Just([
      PostAtomicNestedCommentEntity(
        nestedCommentId: "\(Int.random(in: 1000...7777))",
        authorId: "test1234",
        comment: "야호!!",
        createAt: createAt,
        hearts: 0),
      PostAtomicNestedCommentEntity(
        nestedCommentId: "\(Int.random(in: 1000...7777))",
        authorId: "test1235",
        comment: "야호!!",
        createAt: createAt,
        hearts: 0),
      PostAtomicNestedCommentEntity(
        nestedCommentId: "\(Int.random(in: 1000...7777))",
        authorId: "test1236",
        comment: "야호!!",
        createAt: createAt,
        hearts: 0)
    ]).setAnyErrorAndEraseToAnyPublisher()
  }
  
  func fetchTheNumberOfNestedComments(
    postId: String,
    commentId: String
  ) -> AnyPublisher<Int, any Error> {
    Just(2).setAnyErrorAndEraseToAnyPublisher()
  }
  
  func sendNestedComment(
    ownerId: String,
    postId: String,
    commentId: String, 
    comment: String
  ) -> AnyPublisher<travelPlan.PostAtomicNestedCommentEntity, any Error> {
    return Just(PostAtomicNestedCommentEntity(
      nestedCommentId: "1111", 
      authorId: "1231",
      comment: comment,
      createAt: createAt,
      hearts: 0))
    .setAnyErrorAndEraseToAnyPublisher()
  }
  
  func updateNestedComment(
    postId: String,
    commentId: String,
    nestedCommentId: String,
    comment: String
  ) -> AnyPublisher<Void, any Error> {
    return Just(()).setAnyErrorAndEraseToAnyPublisher()
  }
  
  func deleteNestedComment(
    postId: String,
    commentId: String,
    nestedCommentId: String
  ) -> AnyPublisher<Void, any Error> {
    return Just(()).setAnyErrorAndEraseToAnyPublisher()
  }
  
  func deleteAllNestedComments(
    postId: String,
    commentId: String
  ) -> AnyPublisher<Void, any Error> {
    return Just(()).setAnyErrorAndEraseToAnyPublisher()
  }
}
