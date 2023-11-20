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
  var sut: Endpoint<UserNameResponseDTO>!
  var mockRequestModel: UserNameRequestDTO!
  let mockSession = MockSession.default
  var expectation: XCTestExpectation!
  
  // MARK: - Lifecycle
  override func setUp() {
    super.setUp()
    mockRequestModel = UserNameRequestDTO(name: "배고프다", id: 777)
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
    expectation = expectation(description: "finish")
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    mockRequestModel = nil
    expectation = nil
  }
}

extension EndpointTests {
  func testMakeRequest_DataRequest의AbsoluteURL검사할때_ShouldReturnEqaul() {
    // Arrange
    let targetURL = URL(string: "http://test.com/user/name-update?id=777&name=배고프다")
    
    // Act
    DispatchQueue.global().async { [unowned self] in
      let dataRequest = try? sut.makeRequest(from: mockSession)
      
      // Assert
      XCTAssertNotNil(dataRequest, "DataRequest를 반환해야하는데 nil반환")
      XCTAssertNotNil(dataRequest?.convertible.urlRequest, "DataRequest의 urlRequest를 반환해야하는데 nil반환")
      XCTAssertEqual(
        dataRequest?.convertible.urlRequest?.url, targetURL)
      expectation.fulfill()
    }
    
    wait(for: [expectation], timeout: 10)
  }
  
  func testMakeReqeust_DataReqeust의HttpMethod가Post일때_shouldReturnNotNil() {
    // Arrange
    sut.method = .post
    let targetURL = URL(string: "http://test.com/user/name-update")
    
    // Act
    DispatchQueue.global().async { [unowned self] in
      let dataRequest = try? sut.makeRequest(from: mockSession)
      
      // Assert
      XCTAssertNotNil(dataRequest, "DataRequest를 반환해야하는데 nil반환")
      XCTAssertNotNil(dataRequest?.convertible.urlRequest, "DataRequest의 urlRequest를 반환해야하는데 nil반환")
      XCTAssertEqual(
        dataRequest?.convertible.urlRequest?.url, targetURL)
      expectation.fulfill()
    }
    
    wait(for: [expectation], timeout: 10)
  }
  
  func testMakeRequest_DataRequest의HttpMethod가Post이고_HttpBody가값이있을때_shouldReturnSuccess() {
    // Arrange
    sut.method = .post
    
    // Act
    DispatchQueue.global().async { [unowned self] in
      let dataRequest = try? sut.makeRequest(from: mockSession)
      
      // Assert
      XCTAssertNotNil(dataRequest, "DataRequest를 반환해야하는데 nil반환")
      XCTAssertNotNil(dataRequest?.convertible.urlRequest, "DataRequest의 urlRequest를 반환해야하는데 nil반환")
      XCTAssertNotEqual(
        dataRequest?.convertible.urlRequest?.httpBody, .none)
      expectation.fulfill()
    }
    
    wait(for: [expectation], timeout: 10)
  }
}
