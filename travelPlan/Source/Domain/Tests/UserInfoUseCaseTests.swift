//
//  UserInfoUseCaseTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 2/27/24.
//

import XCTest
@testable import travelPlan

final class UserInfoUseCaseTests: XCTestCase {
  // MARK: - Properties
  var sut: UserInfoUseCase!
  let mockUserInfoRepository = MockUserInfoRepository()
  
  // MARK: - Lifecycle
  override func setUp() {
    super.setUp()
    sut = DefaultUserInfoUseCase(userInfoRepository: mockUserInfoRepository)
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
  }
  
  // MARK: - Tests
  func testUserInfoUseCase_사용자의이름이중복됬는지여부를확인할때_ShouldRetrunTrue() {
    // Act
    sut.isDuplicatedName(with: "토익은 어려워")
    let requestedValue = sut.isDuplicatedName
    
    // Assert
    XCTAssertNotNil(requestedValue, "isDuplicatedName 변수 반환값이 bool이어야 하는데 옵셔널 값임")
    XCTAssertTrue(requestedValue!, "isDuplicatedName 변수 반환값이 true여야 하지만 false 반환")
  }
}
