//
//  SessionProviderTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 10/16/23.
//

import Alamofire
import Combine
import XCTest
@testable import travelPlan

final class SessionProviderTests: XCTestCase {
  var sut: Sessionable! = nil
  var mockSession: Session!
  var expectation: XCTestExpectation!
  var subscription: AnyCancellable!

  override func setUp() {
    super.setUp()
    mockSession = MockSession.default
    sut = SessionProvider(session: MockSession.default)
    expectation = expectation(description: "finish")
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    expectation = nil
    mockSession = nil
    subscription = nil
  }
}

extension SessionProviderTests {
  func testUploadUserName_SessionProvider로요청후응답할때ResponseDTO체크_ShouldReturnEqual() {
    // Arrange
    var mockUserNameRequestDTO = UserNameRequestDTO(name: "iosDeveloper:]", id: 1334)
    var mockUserEndpoint = MockUserEndpoint.shared
    let userNameUploadEndpoint = mockUserEndpoint.uploadUserName(with: mockUserNameRequestDTO)
    let responseJSONString = """
      {
        "status": "OK"
      }
      """
    MockUrlProtocol.requestHandler = { _ in
      let responseData = responseJSONString.data(using: .utf8)!
      return ((HTTPURLResponse(), responseData))
    }
    
    // Act
    subscription = sut.request(endpoint: userNameUploadEndpoint)
      .eraseToAnyPublisher()
      .catch {_ in 
        Just(UserNameResponseDTO(status: "False"))
      }
      .sink { [unowned self] responseDTO in
        
        // Assert
        XCTAssertEqual(responseDTO.status, "OK")
        expectation.fulfill()
      }
    wait(for: [expectation], timeout: 10)
  }
}
