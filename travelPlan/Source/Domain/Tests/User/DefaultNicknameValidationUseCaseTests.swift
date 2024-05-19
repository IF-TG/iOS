//
//  DefaultNicknameValidationUseCaseTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/19/24.
//

import XCTest
import Combine
@testable import travelPlan

final class DefaultNicknameValidationUseCaseTests: XCTestCase {
  var sut: NicknameValidationUseCase!
  var subscriptions: Set<AnyCancellable>!
  var stubUserProfileSettingRepository: StubUserProfileSettingRepository!
  var stubOwnerStorage: StubOwnerStorage!
  var expectation: XCTestExpectation!
  
  override func setUp() {
    super.setUp()
    stubUserProfileSettingRepository = StubUserProfileSettingRepository()
    stubOwnerStorage = StubOwnerStorage()
    sut = DefaultNicknameValidationUseCase(
      userProfileSettingRepository: stubUserProfileSettingRepository,
      ownerStorage: stubOwnerStorage)
    subscriptions = []
    expectation = XCTestExpectation(description: "유닛 테스트 시작")
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    subscriptions = nil
    stubOwnerStorage = nil
    stubUserProfileSettingRepository = nil
    expectation = nil
  }
}

// MARK: - Private Heleprs
private extension DefaultNicknameValidationUseCaseTests {
  func validateNicknameForTest(
    nickname: String,
    expectedState: NicknameValidateState
  ) {
    // Arrange
    var unexpectedError: Error?
    var receivedResult: NicknameValidateState = .default
    
    // Act
    sut.validateNickname(nickname)
      .receive(on: RunLoop.current)
      .sink { completion in
        if case .failure(let error) = completion {
          unexpectedError = error
          self.expectation.fulfill()
        }
      } receiveValue: { receivedState in
        receivedResult = receivedState
        self.expectation.fulfill()
      }.store(in: &subscriptions)
    
    wait(for: [expectation], timeout: 7.777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: #function)
    XCTAssertEqual(expectedState, receivedResult, "\(#function): 예상된 반환값과 일치하지 않습니다.")
  }
}

extension DefaultNicknameValidationUseCaseTests {
  func test_validateNickname_WhenInputEnptyNickname_ShouldReturnUdnerflow() {
    validateNicknameForTest(nickname: "", expectedState: .underflow)
  }
  
  
  func test_validateNickname_WhenShortNickname_ShouldReturnUnderflow() {
    validateNicknameForTest(nickname: "GG", expectedState: .underflow)
  }
  
  func test_validateNickname_WhenInputLongNickname_ShouldReturnOverflow() {
    validateNicknameForTest(nickname: "테스트테스트닉네임닉네임닉네임닉네임", expectedState: .overflow)
  }
  
  func test_validateNickname_WhenInputExistingNickname_ShoudReturnDefault() {
    validateNicknameForTest(nickname: stubOwnerStorage.nickname ?? "난짱구", expectedState: .default)
  }
  
  func test_validateNickname_WhenInputNewValidNickanme_NotDuplcated_ShouldReturnAvailable() {
    validateNicknameForTest(nickname: "여행가고싶당", expectedState: .available)
  }
  
  func test_validateNickname_WhenInputNewNickname_Duplidated_ShouldReturnDuplicated() {
    validateNicknameForTest(nickname: "난당근", expectedState: .duplicated)
  }
}
