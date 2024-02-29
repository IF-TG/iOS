//
//  UserInfoUseCaseTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 2/27/24.
//

import XCTest
import Combine
@testable import travelPlan

final class UserInfoUseCaseTests: XCTestCase {
  // MARK: - Properties
  var sut: UserInfoUseCase!
  var subscription: AnyCancellable?
  let mockUserInfoRepository = MockUserInfoRepository()
  var expectation: XCTestExpectation!
  
  // MARK: - Lifecycle
  override func setUp() {
    super.setUp()
    sut = DefaultUserInfoUseCase(userInfoRepository: mockUserInfoRepository)
    expectation = XCTestExpectation(description: "Finish")
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    subscription = nil
    expectation = nil
  }
  
  // MARK: - Tests
  func testUserInfoUseCase_사용자의이름이중복됬는지여부를확인할때_ShouldRetrunTrue() {
    subscription = sut.isDuplicatedName.sink { _ in
    } receiveValue: { [unowned self] requestedValue in
      // Assert
      XCTAssertTrue(requestedValue, "isDuplicatedName 변수 반환값이 true여야 하지만 false 반환")
      expectation.fulfill()
    }
    
    // Act
    sut.isDuplicatedName(with: "토익은 어려워")
    
    wait(for: [expectation], timeout: 5)
  }
}
