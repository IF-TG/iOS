//
//  DefaultPostHeartUseCaseTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 7/13/24.
//

import XCTest
import Combine
@testable import travelPlan

final class DefaultPostHeartUseCaseTests: BaseXCTestCase {
  var sut: PostHeartUseCase!
  
  override func setUp() {
    super.setUp()
    let mockPostRepositoryDecorator = JsonMockPostRepository()
    sut = DefaultPostHeartUseCase(postRepository: mockPostRepositoryDecorator)
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
  }
  
  // MARK: - Tests
  
  func test_whenPostHeart_shouldReturnVoid() {
    // Arrange
    let task = sut.heartPost(777)
    
    // Act
    execute(fromPublisher: task).store(in: &subscriptions)
    wait(for: [expectation], timeout: 7.777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "heartPost")
    XCTAssert(hasReceivedResult, notReceivedErrorMessage)
  }
  
  /// PostRepository의 토글은 결과로 항상 true를 반환함으로, hate시점은 에러를 던져야 합니다.
  func test_whenPostHate_shouldThrowError() {
    // Arrange
    let task = sut.hatePost(777)
    
    // Act
    execute(fromPublisher: task).store(in: &subscriptions)
    wait(for: [expectation], timeout: 30)
    
    // Assert
    XCTAssertFalse(hasReceivedResult, "에러를 던져야 하기 때문에 반환받은 값을 받지 않아야합니다.")
    XCTAssertNotNil(unexpectedError, "에러를 던져야하지만 에러가 던져지지 않았습니다.")
    print(unexpectedError?.localizedDescription)
  }
}
