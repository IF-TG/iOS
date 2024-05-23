//
//  UserBlockUseCaseTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 4/1/24.
//

import XCTest
import Combine
@testable import travelPlan

final class UserBlockUseCaseTests: XCTestCase {
  var sut: UserBlockUseCase!
  var subscription: AnyCancellable?
  let mockRepository = MockWrappedUserBlockRepository()
  var expectation = XCTestExpectation(description: "UserBlockUseCase test!")
  
  // MARK: - Lifecycle
  override func setUp() {
    super.setUp()
    sut = DefaultUserBlockUseCase(userBlockRepository: mockRepository)
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    subscription = nil
  }
}

/// 테스트 목적:
/// URLProtocl을 가로채 서버에서 데이터 받는 json key-value를 json file로 읽어들여 data로 반환합니다.
/// 반환한 데이터를  decoding해서 responseDTO로 변환 후 toDomain으로 entity로 변환받는 유즈케이스 테스트입니다.
extension UserBlockUseCaseTests {
  func testUserBlockUseCase_blockUser함수호출시_entity를받았는지_ShouldReturnTrue() {
    // Arrange
    var result = false
    var unexpectedError: Error?
    
    // Act
    subscription = sut.blockUser(with: "777")
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
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "blockUser")
    XCTAssertTrue(result, notReceivedErrorMessage)
  }
  
  func testUserBlockUseCase_fetchBlockedUsers함수호출시_entity를받았는지_ShouldReturnTrue() {
    // Arrange
    var result = false
    var unexpectedError: Error?
    
    // Act
    subscription = sut.fetchBlockedUsers()
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
    wait(for: [expectation], timeout: 7)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchBlockedUsers")
    XCTAssertTrue(result, notReceivedErrorMessage)
  }
}
