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

extension PostCommentUseCaseTests {
  func testPostCommentUseCase_sendComment함수호출시_postCommentEntity를받았는지_ShouldReturnTrue() {
    // Arrange
    var result = false
    var unexpectedError: Error?
    
    // Act
    subscription = sut.sendComment(postId: 1, comment: "코멘트!")
      .sink { [unowned self] completion in
        if case .failure(let error) = completion {
          unexpectedError = error
        }
        expectation.fulfill()
      } receiveValue: { [unowned self] postCommentEntity in
        print("DEBUG: 값을 성공적으로 받았습니다~\n\n:\(postCommentEntity)")
        result = true
        expectation.fulfill()
      }
    wait(for: [expectation], timeout: 7.777777777)
    
    // Assert
    if let unexpectedError {
      XCTAssert(
        false,
        """
          testPostCommentUseCase's sendComemnt 함수 호출시 postCommentEntity를 받아야 하지만 에러가 발생됬습니다.
          Occured error description: \(unexpectedError.localizedDescription)
        """
      )
    }
    XCTAssertTrue(
      result,
    "testPostCommentUseCase의 sendComment()를 호출했을 때 postCommentEntity를 받아야 하지만 upstream이 종료됬습니다")
        
  }
}
