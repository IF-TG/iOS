//
//  EndpointTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 10/15/23.
//

import XCTest
import Alamofire
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
      parameters: [.query(mockRequestModel)],
      requestType: .custom("user/name-update"))
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
    let targetURL = URL(string: "http://test.com/user/name-update?commentId=777&name=배고프다")
    
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
  
  /// ex) body Parameter :  { profile: String }  + query Parameter : { userId :  long  } 이 두개가 한 요청에 url에 담겨야 할 경우에 대한 테스트입니다.
  func testEndPoint_makeRequest할때_두개의Parameters가_사용될_경우_AbsoluteURL이_잘_만들어지는지_shouldReturnEqaul() {
    // Arrange
    // 이 객체가 url의 query param에 담겨야 합니다.
    struct TempQueryParameterReqeustDTO: Encodable {
      // 만약 사용자 액세스 토큰을 HTTP header말고 query param에 같이 보내야 한다면?
      let accessToken: String
    }
    
    let targetURL = URL(string: "http://test.com/user/name-update?accessToken=ab1@2")
    let mockReqeustQueryParamDTO = TempQueryParameterReqeustDTO(accessToken: "ab1@2")
    mockRequestModel = UserNameRequestDTO(name: "배고프다", id: 777)
    sut = Endpoint(
      scheme: "http",
      host: "test.com",
      method: .post,
      parameters: [.query(mockReqeustQueryParamDTO), .body(mockRequestModel)],
      requestType: .custom("user/name-update"))
    var dataRequest: DataRequest?
    
    // Act
    DispatchQueue.global().async { [unowned self] in
      dataRequest = try? sut.makeRequest(from: mockSession)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 10)
    
    // Assert
    XCTAssertNotNil(dataRequest, "DataRequest를 반환해야하는데 nil반환")
    XCTAssertNotNil(dataRequest?.convertible.urlRequest, "DataRequest의 urlRequest를 반환해야하는데 nil반환")
    XCTAssertEqual(
      dataRequest?.convertible.urlRequest?.url, targetURL)
  }
  
  /// ex) body Parameter :  { profile: String }  + query Parameter : { userId :  long  } 이 두개가 한 요청에 url에 담겨야 할 경우에 대한 테스트입니다.
  func testEndPoint_makeRequest할때_두개의Parameters가_사용될_경우_bodyParam이_httpBody에_잘_추가되는지_shouldReturnEqual() {
    // Arrange
    // 이 객체가 url의 query param에 담겨야 합니다.
    struct TempQueryParameterReqeustDTO: Encodable {
      // 만약 사용자 액세스 토큰을 HTTP header말고 query param에 같이 보내야 한다면?
      let accessToken: String
    }
    
    let mockReqeustQueryParamDTO = TempQueryParameterReqeustDTO(accessToken: "ab1@2")
    mockRequestModel = UserNameRequestDTO(name: "nice", id: 777)
    let expectedJsonString = "commentId=\(mockRequestModel.id)&name=\(mockRequestModel.name)"
    sut = Endpoint(
      scheme: "http",
      host: "test.com",
      method: .post,
      parameters: [.query(mockReqeustQueryParamDTO), .body(mockRequestModel)],
      requestType: .custom("user/name-update"))
    var dataRequest: DataRequest?
    
    // Act
    DispatchQueue.global().async { [unowned self] in
      dataRequest = try? sut.makeRequest(from: mockSession)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 10)
    
    // Assert
    XCTAssertNotNil(dataRequest, "DataRequest를 반환해야하는데 nil반환")
    XCTAssertNotNil(dataRequest?.convertible.urlRequest?.httpBody, "httpBody에 값이 담겨야 하는데 nil 반환")
    let testData = dataRequest!.convertible.urlRequest!.httpBody!
    let testString = String(data: testData, encoding: .utf8) ?? "no"
    XCTAssertEqual(testString, expectedJsonString)
  }
}
