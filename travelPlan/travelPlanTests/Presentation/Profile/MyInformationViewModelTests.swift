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
    let sessionProvider = SessionProvider(session: mockSession)
    let repository = DefaultUserInfoRepository(service: sessionProvider)
    let useCase = DefaultUserInfoUseCase(userInfoRepository: repository)
    sut = MyInformationViewModel(userInfoUseCase: useCase)
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
    // Arrange
    let json = """
      {
        "result": true,
        "status": "OK",
        "statusCode": "200",
        "message": "success"
      }
      """
    MockUrlProtocol.requestHandler = { _ in
      let responseData = json.data(using: .utf8)!
      return ((HTTPURLResponse(), responseData))
    }
    expectation = expectation(description: "isDuplicatedUserNameExpectation.")
    
    // Act
    let output = sut.transform(input)
    subscription = output.sink { [unowned self] _ in
      expectation.fulfill()
    } receiveValue: { [unowned self] viewControllerState in
      // Assert
      switch viewControllerState {
      case .duplicatedNickname:
        XCTAssert(true)
        expectation.fulfill()
      case .availableNickname:
        XCTAssert(false, "MyInformationVM에서 사용자가 입력한 닉네임 중복 체크 로직에서 true가 나와야 하는데 false가 나옴")
        expectation.fulfill()
      default:
        break
      }
    }
    input.isNicknameDuplicated.send("이름새로지었음")
    wait(for: [expectation], timeout: 6)
  }
}
