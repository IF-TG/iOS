//
//  PostCommentUseCaseTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 3/23/24.
//

import XCTest
@testable import travelPlan
import Combine

final class PostCommentUseCaseTests: XCTestCase {
  var sut: PostCommentUseCase!
  var subscription: AnyCancellable?
  let mockPostCommentRepository = MockPostCommentRepository()
  var expectation = XCTestExpectation(description: "PostCommentUseCase test!")
  
  // MARK: - Lifecycle
  override func setUp() {
    super.setUp()
    sut = DefaultPostCommentUseCase(postCommentRepository: mockPostCommentRepository)
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    subscription = nil
  }  
}
