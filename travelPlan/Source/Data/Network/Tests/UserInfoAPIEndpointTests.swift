//
//  UserInfoAPIEndpointTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 2/27/24.
//

import XCTest
@testable import travelPlan

final class UserInfoAPIEndpointTests: XCTestCase {
  // MARK: - Properties
  var sut: UserInfoAPIEndpoint = UserInfoAPIEndpoint.default
  let mockSession = MockSession.default
  var expectation: XCTestExpectation!
  
  override func setUp() {
    super.setUp()
    MockUrlProtocol.requestHandler = { _ in return ((HTTPURLResponse(), Data())) }
    expectation = expectation(description: "finish")
  }
  
  override func tearDown() {
    super.tearDown()
    expectation = nil
  }
  
  // MARK: - Tests
  /// 계속 테스트 실패했는데 이유가 dataRequest의 convertible에서 urlRequest 객체 생성이 안됬다. 그 이유는 host에 로컬포트번호를 작성하지 않고 그냥 scheme에 scheme + :// + localhost:8080까지 썼기 때문에 url형식이 잘못됬다.
  func testUserInfoAPIEndpoint_isDuplicatedName함수의Endpoint를통해makeRequest호출할때AbsoluteURL이정확한지_ShouldReturnEqual() {
    // Arrange
    let targetURL = URL(string: "http://localhost:8080/nickname?nickname=토익은어려워")
    let requestDTO = UserNicknameRequestDTO(nickname: "토익은어려워")
    let userNicknameEndpoint = sut.isDuplicatedNickname(with: requestDTO)
    
    // Act
    DispatchQueue.global().async { [unowned self] in
      let dataRequest = try? userNicknameEndpoint.makeRequest(from: mockSession)
      
      // Assert
      XCTAssertNotNil(dataRequest, "UserIfnoAPIEndpoint의 isDuplicatedName()에서 DataRequest를 반환해야 하는데 nil 반환")
      XCTAssertNotNil(
        dataRequest?.convertible.urlRequest,
        "UserIfnoAPIEndpoint의 isDuplicatedName()에서 DataRequest의 urlRequest를 반환해야하는데 nil 반환")
      XCTAssertEqual(dataRequest?.convertible.urlRequest?.url, targetURL)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 10)
  }
}
