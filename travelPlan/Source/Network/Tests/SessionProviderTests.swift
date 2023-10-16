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
  let mockUserNameRequestDTO = UserNameRequestDTO(name: "iosDeveloper:]", id: 1334)
  var mockUserEndpoint: MockUserEndpoint!
  var sut: Sessionable! = nil
  var mockSession: Session!
  var expectation: XCTestExpectation!
  var subscription: AnyCancellable!

  override func setUp() {
    super.setUp()
    mockSession = MockSession.default
    mockUserEndpoint = MockUserEndpoint.shared
    sut = SessionProvider(session: MockSession.default)
    expectation = expectation(description: "finish")
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    mockUserEndpoint = nil
    expectation = nil
    mockSession = nil
    subscription = nil
  }
}

extension SessionProviderTests {
  func testUploadUserName_SessionProvider로요청후응답할때ResponseDTO체크_ShouldReturnEqual() {
    // Arrange
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
      .catch {_ in Just(UserNameResponseDTO(status: "False")) }
      .sink { [unowned self] responseDTO in
        
        // Assert
        XCTAssertEqual(responseDTO.status, "OK")
        expectation.fulfill()
      }
    wait(for: [expectation], timeout: 10)
  }
  
  func testUploadUserName_SessionProvider로요청후응답할때StatusCode404일때_ShouldReturnFailure() {
    // Arrange
    let userNameUploadEndpoint = mockUserEndpoint.uploadUserName(with: mockUserNameRequestDTO)
    MockUrlProtocol.requestHandler = { _ in
      let mockUrl = URL(string: "https://test.com...")!
      let httpResponse = HTTPURLResponse(url: mockUrl, statusCode: 404, httpVersion: nil, headerFields: nil)!
      return ((httpResponse, Data()))
    }
    
    // Act
    subscription = sut.request(endpoint: userNameUploadEndpoint)
      .sink(receiveCompletion: { [unowned self] completion in
        
        // Assert
        switch completion {
        case .finished:
          XCTAssert(false, "Reqeust의 결과로 Failure를 반환해야하는데 subscription의 completion이 반환됨")
        case .failure(let error):
          XCTAssertEqual(
            error.responseCode!, 404,
            " Request의 결과로 서버에서 요청 데이터를 찾을 수 없다는 결과 404가 반환되야하는데 다른 statusCode가 반환됨")
        }
        expectation.fulfill()
      }, receiveValue: { [unowned self] _ in
        XCTAssert(false, "Request의 결과로 Failure를 반환해야하는데 이상한 response DTO 값이 반환됨.")
        expectation.fulfill()
      })
    wait(for: [expectation], timeout: 7)
  }
}
