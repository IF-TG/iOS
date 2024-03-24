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
  var testFunctionName: String = ""
  
  // MARK: - Lifecycle
  override func setUp() {
    super.setUp()
    sut = DefaultPostCommentUseCase(postCommentRepository: mockPostCommentRepository)
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    subscription = nil
    testFunctionName = ""
  }
}

// MARK: - Helpers
private extension PostCommentUseCaseTests {
  func checkIfUnexpectedErrorOccured(_ error: Error?) {
    guard let error else { return }
    XCTAssert(
      false,
        """
          testPostCommentUseCase's \(testFunctionName) 함수 호출시 entity를 받아야 하지만 에러가 발생됬습니다.
          Occured error description: \(error.localizedDescription)
        """
    )
  }
  
  var notReceivedErrorMessage: String {
    "testPostCommentUseCase의 \(testFunctionName)()를 호출했을 때 Entity를 받아야 하지만 upstream이 종료됬습니다"
  }
}

/// JsonString 목데이터 주입시 response data가 특정 responseDTO로 decodable이 되는지 테스트
/// decoded된 responseDTO가 특정 entity로 mapping이 되는지 테스트
extension PostCommentUseCaseTests {
  func testPostCommentUseCase_sendComment함수호출시_postCommentEntity를받았는지_ShouldReturnTrue() {
    // Arrange
    var result = false
    var unexpectedError: Error?
    testFunctionName = "sendComment"
    
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
    checkIfUnexpectedErrorOccured(unexpectedError)
    XCTAssertTrue(result, notReceivedErrorMessage)
  }
  
  func testPostCommentUseCase_updateComment함수호출시_UpdatedPostCommentEntity받았는지_ShouldReturnTrue() {
    // Arrange
    var result = false
    var unexpectedError: Error?
    testFunctionName = "updateComment"
    
    // Act
    subscription = sut.updateComment(commentId: 1, comment: "정상을 향해~ (등산가야지~..~)")
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
    checkIfUnexpectedErrorOccured(unexpectedError)
    XCTAssertTrue(result, notReceivedErrorMessage)
  }
  
  func testPostCommentUseCase_deleteComment함수호출시_데이터삭제인true를받았는지_ShouldReturnTrue() {
    // Arrange
    var result = false
    var unexpectedError: Error?
    testFunctionName = "deleteComment"
    
    // Act
    subscription = sut.deleteComment(commentId: 1)
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
    checkIfUnexpectedErrorOccured(unexpectedError)
    XCTAssertTrue(result, notReceivedErrorMessage)

  }
}
