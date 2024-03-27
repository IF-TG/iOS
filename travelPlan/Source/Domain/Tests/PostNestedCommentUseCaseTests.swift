//
//  PostNestedCommentUseCaseTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 3/27/24.
//

import XCTest
import Combine
@testable import travelPlan

final class PostNestedCommentUseCaseTests: XCTestCase {
  var sut: PostNestedCommentUseCase!
  var subscription: AnyCancellable?
  let mockRepository = MockPostNestedCommentRepository()
  var expectation = XCTestExpectation(description: "PostNestedComment test!")
  var testFunctionName: String = ""
  
  // MARK: - Lifecycle
  override func setUp() {
    super.setUp()
    sut = DefaultPostNestedCommentUseCase(
      postNestedCommentRepository: mockRepository)
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    subscription = nil
    testFunctionName = ""
  }
}

/// 테스트 목적:
/// URLProtocl을 가로채 서버에서 데이터 받는 json key-value를 json file로 읽어들여 data로 반환합니다.
/// 반환한 데이터를  decoding해서 responseDTO로 변환 후 toDomain으로 entity로 변환받는 유즈케이스 테스트입니다.
extension PostNestedCommentUseCaseTests {
  func testPostNestedCommentUseCase_sendNestedComment함수호출시_연관entity를받았는지_ShouldReturnTrue() {
    // Arrange
    var result = false
    var unexpectedError: Error?
    
    // Act
    subscription = sut.sendNestedComment(commentId: 1, comment: "대댓글대댓글")
      .sink { [unowned self] completion in
        if case .failure(let error) = completion {
          unexpectedError = error
        }
        expectation.fulfill()
      } receiveValue: { [unowned self] postNestedCommentEntity in
        print("DEBUG: 값을 성공적으로 받았습니다~\n\n:\(postNestedCommentEntity)")
        result = true
        expectation.fulfill()
      }
    wait(for: [expectation], timeout: 7)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "sendNestedComment")
    XCTAssertTrue(result, notReceivedErrorMessage)
  }
  
  func testPostNestedComemntUseCase_updateNestedComment함수호출시_연관entity를받았는지_ShouldReturnTrue() {
    // Arrange
    var result = false
    var unexpectedError: Error?
    
    // Act
    subscription = sut.updateNestedComment(nestedCommentId: 333, comment: "대댓글 대댓글수정")
      .sink { [unowned self] completion in
        if case .failure(let error) = completion {
          unexpectedError = error
        }
        expectation.fulfill()
      } receiveValue: { [unowned self] response in
        print("DEBUG: 값을 성공적으로 받았습니다~\n\n:\(response)")
        result = true
        expectation.fulfill()
      }
    wait(for: [expectation], timeout: 7)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "updateNestedComment")
    XCTAssertTrue(result, notReceivedErrorMessage)
  }
}
