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
  func testUserInfoUseCase_checkIfNicknameDuplicate함수를통해_사용자의이름이중복됬는지여부를확인할때_ShouldRetrunTrue() {
    subscription = sut.isNicknameDuplicated.sink { _ in
    } receiveValue: { [unowned self] requestedValue in
      // Assert
      XCTAssertTrue(requestedValue, "isDuplicatedName 변수 반환값이 true여야 하지만 false 반환")
      expectation.fulfill()
    }
    
    // Act
    sut.checkIfNicknameDuplicate(with: "토익은 어려워")
    
    wait(for: [expectation], timeout: 5)
  }
  
  func testUserInfoUseCase_updateNickname함수를통해_이름업데이트할때_이미_다른사용자가_사용중인이름이라면_ShouldReturnFalse() {
    // Arrange
    var testResultValue = true
    
    // Act
    subscription = sut.isNicknameUpdated.sink { _ in
    } receiveValue: { [unowned self] in
      testResultValue = $0
      expectation.fulfill()
    }
    sut.updateNickname(with: "토익은정말어려워")
    wait(for: [expectation], timeout: 5)
    
    // Assert
    XCTAssertFalse(
      testResultValue,
      "isNicknameUpdated 반환 값이 true여야 하지만 false반환")
  }
  
  func testUserInfoUseCase_updateNickname함수를통해_이름업데이트할때_성공적으로_변경됬다면_ShouldReturnTrue() {
    // Arrange
    var testResultValue = false
    
    // Act
    subscription = sut.isNicknameUpdated.sink { _ in
    } receiveValue: { [unowned self] in
      testResultValue = $0
      expectation.fulfill()
    }
    sut.updateNickname(with: "어려운건 정복해나가는 맛이 있는거지")
    wait(for: [expectation], timeout: 3.1)
    
    // Assert
    XCTAssertTrue(
      testResultValue,
      "isNicknameUpdated 반환 값이 true여야 하지만 false반환")
  }
  
  func testUserInfoUseCase_updateProfile함수를통해_프로필업데이트성공적일때_isProfileUpdated프로퍼티가_ShouldReturnEqual() {
    // Arrange
    var resultValue = false
    let expectedValue = true
    
    // Act
    subscription = sut.isProfileUpdated.sink { _ in
    } receiveValue: { [unowned self] in
      resultValue = $0
      expectation.fulfill()
    }
    sut.updateProfile(with: "base64인코딩된데이터")
    wait(for: [expectation], timeout: 3.00001)
    
    // Assert
    XCTAssertEqual(
      resultValue,
      expectedValue,
      "updateProfile()함수를통해 서버에 호출한 결과로 isProfileUdpated프로퍼티가 true가 반환되야하는데 false반환됨.")
  }
  
  func testUserInfoUseCase_updateProfile함수를통해_프로필업데이트가실패했을때_isProfileUpdated프로퍼티가_ShouldReturnFalse() {
    // Arrange
    var resultValue = true
    
    // Act
    subscription = sut.isProfileUpdated.sink { _ in
    } receiveValue: { [unowned self] in
      resultValue = $0
      expectation.fulfill()
    }
    sut.updateProfile(with: "무슨이유에서인지실패..")
    wait(for: [expectation], timeout: 3.00001)
    
    // Assert
    XCTAssertFalse(
      resultValue,
      "updateProfile()함수를통해 서버에 호출한 결과로 isProfileUdpated프로퍼티가 false가 반환되야하는데 true반환됨.")
  }
  
  func testUserInfoUseCase_saveProfile함수를통해_프로필저장이_성공했을때_isProfileSaved프로퍼티_ShouldReturnTrue() {
    // Arrange
    var resultValue = false
    
    // Act
    subscription = sut.isProfileSaved.sink { _ in
    } receiveValue: { [unowned self] in
      resultValue = $0
      expectation.fulfill()
    }
    sut.saveProfile(with: "성장해나가자보자구!!!")
    wait(for: [expectation], timeout: 4)
    
    // Assert
    XCTAssertTrue(
      resultValue,
      "saveProfile()함수를통해 서버에 호출한 결과로 isProfileSaved프로퍼티가 true가 반환되야하는데 false반환됨.")
  }
  
  func testUserInfoUseCase_saveProfile함수를통해_프로필저장이_실패했을때_isProfileSaved프로퍼티_ShouldReturnFalse() {
    // Arrange
    var resultValue = true
    
    // Act
    subscription = sut.isProfileSaved.sink { _ in
    } receiveValue: { [unowned self] in
      resultValue = $0
      expectation.fulfill()
    }
    sut.saveProfile(with: "!!!!")
    wait(for: [expectation], timeout: 4)
    
    // Assert
    XCTAssertFalse(
      resultValue,
      "saveProfile()함수를통해 서버에 호출한 결과로 isProfileSaved프로퍼티가 false가 반환되야하는데 true반환됨.")
  }
  
  func testUserInfoUseCase_fetchProfile함수를통해_사용자의프로필을받아올때_fetchedProfile프로퍼티_반환값이예상값과일치하는지_ShouldReturnEqual() {
    // Arrange
    let expectedProfileEntity = ProfileImageEntity(image: "hi")
    var requestedProfileEntity = ProfileImageEntity(image: "")
    
    // Act
    subscription = sut.fetchedProfile.sink { _ in
    } receiveValue: { [unowned self] requestedValue in
      requestedProfileEntity = requestedValue
      expectation.fulfill()
    }
    sut.fetchProfile()
    wait(for: [expectation], timeout: 5)
    
    // Assert
    XCTAssertEqual(
      expectedProfileEntity.image,
      requestedProfileEntity.image,
      "isDuplicatedName 변수 반환값이 true여야 하지만 false 반환")
  }
}
