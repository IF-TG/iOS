//
//  PostCommentHeartUseCaseTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/6/24.
//

import XCTest
import Combine
@testable import travelPlan

final class PostCommentHeartUseCaseTests: XCTestCase {
  var sut: PostCommentHeartUseCase!
  var subscription: AnyCancellable?
  let mockPostCommentRepository = MockPostCommentRepository()
  var expectation = XCTestExpectation(description: "PostCommentUseCase test!")
  
  // MARK: - Lifecycle
  override func setUp() {
    super.setUp()
    sut = DefaultPostCommentHeartUseCase(postCommentRepository: mockPostCommentRepository)
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    subscription = nil
  }


  func testPostCommentHeartUseCase_togglePostComment함수호출시_PostComemntEntities받았는지_ShouldReturnTrue() {
    // Arrange
    var result = false
    var unexpectedError: Error?
    
    // Act
    subscription = sut.toggleCommentHeart(postId: 1,commentId: 1)
      .sink { [unowned self] completion in
        if case .failure(let error) = completion {
          unexpectedError = error
        }
        expectation.fulfill()
      } receiveValue: { [unowned self] entity in
        print("DEBUG: 값을 성공적으로 받았습니다~\n\n:\(entity)")
        result = true
        expectation.fulfill()
      }
    wait(for: [expectation], timeout: 7.777777777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "toggleCommentHeart")
    XCTAssertTrue(result, notReceivedErrorMessage)
  }
}
