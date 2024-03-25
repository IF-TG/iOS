//
//  MyInformationViewModelTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 2/29/24.
//

import XCTest
import Combine
@testable import travelPlan

final class MyInformationViewModelTests: XCTestCase {
  // MARK: - Properties
  var sut: (any MyInformationViewModelable)!
  var input: MyInformationViewModel.Input!
  let mockSession = MockSession.default
  var expectation: XCTestExpectation!
  var subscription: AnyCancellable?
  
  // MARK: - Lifecycle
  override func setUp() {
    super.setUp()
    let useCase = MockMyProfileUseCase()
<<<<<<< HEAD
    let mockUserStorage = MockUserStorage()
    let loggedInUserRepository = DefaultLoggedInUserRepository(storage: mockUserStorage)
    let loggedInUserUseCase = DefaultLoggedInUserUseCase(loggedInUserRepository: loggedInUserRepository)
    sut = MyInformationViewModel(myProfileUseCase: useCase, loggedInUserUseCase: loggedInUserUseCase)
=======
    let mockStroage = MockUserStorage()
    let defaultLoggedInUserRepository = DefaultLoggedInUserRepository(storage: mockStroage)
    let defaultLoggedInUserUseCase = DefaultLoggedInUserUseCase(loggedInUserRepository: defaultLoggedInUserRepository)
    sut = MyInformationViewModel(
      myProfileUseCase: useCase,
      loggedInUserUseCase: defaultLoggedInUserUseCase)
>>>>>>> f2fda904791ded5e5cecceb84f42912dbafe4d52
    input = MyInformationViewModel.Input()
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    expectation = nil
    subscription = nil
    input = nil
  }
}

extension MyInformationViewModelTests {
  func testMyInformationVM_사용자가입력한닉네임이중복일때_ShouldReturnTrue() {
    expectation = expectation(description: "MyInformationVM Input.inputNickname.")
    expectation.expectedFulfillmentCount = 2
    
    // Act
    let output = sut.transform(input)
    subscription = output.sink { [unowned self] completion in
      expectation.fulfill()
    } receiveValue: { [unowned self] viewControllerState in
      // Assert
      switch viewControllerState {
      case .nicknameState(.duplicated):
        XCTAssert(true)
        expectation.fulfill()
      case .nicknameState(.available):
        XCTAssert(false, "MyInformationVM에서 사용자가 입력한 닉네임 중복 체크 로직에서 중복 true가 나와야 하는데 false가 나옴")
        expectation.fulfill()
      case .unexpectedError(let description):
        XCTAssert(false, "얘기치 못한 에러 발생: \(description)")
        expectation.fulfill()
      case .networkProcessing:
        expectation.fulfill()
      default:
        XCTAssertFalse(true, "예기치 못한 viewController's state 발생")
        break
      }
    }
    input.revisedNicknameInput.send("무야호")
    wait(for: [expectation], timeout: 6)
  }
}
