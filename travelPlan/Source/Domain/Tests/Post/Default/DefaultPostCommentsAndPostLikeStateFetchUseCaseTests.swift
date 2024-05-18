//
//  DefaultPostCommentsAndPostLikeStateFetchUseCaseTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/16/24.
//

import XCTest
import Combine
@testable import travelPlan

final class DefaultPostCommentsAndPostLikeStateFetchUseCaseTests: XCTestCase {
  var sut: PostCommentsAndPostLikeStateFetchUseCase!
  var mockRepository: PostRepository!
  var subscription: AnyCancellable?
  var expectation: XCTestExpectation!
  
  // MARK: - Lifecycle
  override func setUp() {
    super.setUp()
    mockRepository = MockPostRepository()
    sut = DefaultPostCommentsAndPostLikeStateFetchUseCase(postRepository: mockRepository)
    expectation = XCTestExpectation(description: "Finish")
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    subscription = nil
    expectation = nil
  }
}

extension DefaultPostCommentsAndPostLikeStateFetchUseCaseTests {
  func test_fetchComments호출시_mockJson을디코딩해_PostCommentContainer를_받는경우_ShouldReturnTrue() {
    // Arrange
    let mockReqeustValue = PostCommentsRequestValue(page: 1, perPage: 5, postId: "1")
    var result = false
    var unexpectedError: Error?
    
    // Act
    let sutPublisher = sut.fetchCommentsAndPostLikeStatus(with: mockReqeustValue)
    subscription = sink(fromPublisher: sutPublisher, withExpectation: expectation) { err, res in
      unexpectedError = err
      result = res
    }
    wait(for: [expectation], timeout: 7)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchCommentsAndPostLikeStatus")
    XCTAssertTrue(result, notReceivedErrorMessage)
  }
}
