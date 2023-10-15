//
//  EndpointTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 10/15/23.
//

import XCTest

@testable import travelPlan

final class EndpointTests: XCTestCase {
  // MARK: - Properties
  var sut: Endpoint<UserNameResponseModel>!
  var mockRequestModel: UserNameRequestModel!
  
  // MARK: - Lifecycle
  override func setUp() {
    super.setUp()
    mockRequestModel = UserNameRequestModel(name: "배고프다", id: 777)
    sut = Endpoint(
      scheme: "http",
      host: "test.com",
      method: .get,
      prefixPath: "/user",
      parameters: mockRequestModel,
      requestType: .custom("name-update"))
    MockUrlProtocol.requestHandler = { _ in
      return ((HTTPURLResponse(), Data()))
    }
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    mockRequestModel = nil
  }
}

extension EndpointTests {
  func testMakeRequest_DataRequest의AbsoluteURL검사할때_ShouldReturnEqaul() {
    // Arrange
    let mockSession = MockSessionProvider.session
    let targetURL = URL(string: "http://test.com/user/name-update?id=777&name=배고프다")
    let requestExpectation = expectation(description: "Request should finish")
    
    // Act
    DispatchQueue.global().async {
      var dataRequest = try? self.sut.makeRequest(from: mockSession)
      
      // Assert
      XCTAssertNotNil(dataRequest, "DataRequest를 반환해야하는데 nil반환")
      XCTAssertNotNil(dataRequest?.convertible.urlRequest, "DataRequest의 urlRequest를 반환해야하는데 nil반환")
      XCTAssertEqual(
        dataRequest?.convertible.urlRequest?.url, targetURL)
      requestExpectation.fulfill()
    }
    
    wait(for: [requestExpectation], timeout: 10)
  }
}
