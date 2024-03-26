//
//  UserInfoAPIEndpointTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 2/27/24.
//

import XCTest
import Alamofire
@testable import travelPlan

final class UserInfoAPIEndpointTests: XCTestCase {
  // MARK: - Properties
  typealias sut = UserInfoAPIEndpoint
  let mockSession = MockSession.default
  var expectation: XCTestExpectation!
  
  override func setUp() {
    super.setUp()
    MockUrlProtocol.requestHandler = { _ in return ((HTTPURLResponse(), Data())) }
  }
  
  override func tearDown() {
    super.tearDown()
    expectation = nil
  }
  
  // MARK: - Tests
  /// 계속 테스트 실패했는데 이유가 dataRequest의 convertible에서 urlRequest 객체 생성이 안됬다. 그 이유는 host에 로컬포트번호를 작성하지 않고 그냥 scheme에 scheme + :// + localhost:8080까지 썼기 때문에 url형식이 잘못됬다.
  func testUserInfoAPIEndpoint_checkIfNicknameDuplicate함수의Endpoint를통해makeRequest호출할때AbsoluteURL이정확한지_ShouldReturnEqual() {
    // Arrange
    let targetURL = URL(string: "http://localhost:8080/nickname?nickname=토익은어려워")
    let requestDTO = UserNicknameRequestDTO(nickname: "토익은어려워")
    let userNicknameEndpoint = sut.checkIfNicknameDuplicate(with: requestDTO)
    expectation = expectation(description: "CheckIfNicknameDuplicate finish")
    // Act
    DispatchQueue.global().async { [unowned self] in
      let dataRequest = try? userNicknameEndpoint.makeRequest(from: mockSession)
      
      // Assert
      XCTAssertNotNil(dataRequest, "UserInfoAPIEndpoint의 checkIfNicknameDuplicate()에서 DataRequest를 반환해야 하는데 nil 반환")
      XCTAssertNotNil(
        dataRequest?.convertible.urlRequest,
        "UserInfoAPIEndpoint의 checkIfNicknameDuplicate()에서 DataRequest의 urlRequest를 반환해야하는데 nil 반환")
      XCTAssertEqual(dataRequest?.convertible.urlRequest?.url, targetURL)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 10)
  }
  
  func testUserInfoAPIEndpoint_UpdateUserNickname를_통해_makeRequest를_호출할때_AbsoluteURL이_정확한지_ShouldReturnEqual() {
    // Arrange
    let targetURL = URL(string: "http://localhost:8080/nickname")
    let requestDTO = UserNicknamePatchRequestDTO(nickname: "이름추천부탁", userId: 7)
    let endpoint = sut.updateUserNickname(with: requestDTO)
    expectation = expectation(description: "UpdateUserNickname finish")
    // Act
    DispatchQueue.global().async { [unowned self] in
      let dataRequest = try? endpoint.makeRequest(from: mockSession)
      
      // Assert
      XCTAssertNotNil(dataRequest, "UserInfoAPIEndpoint의 updateUserNickname()에서 DataRequest를 반환해야 하는데 nil 반환")
      XCTAssertNotNil(
        dataRequest?.convertible.urlRequest,
        "UserInfoAPIEndpoint의 updateUserNickname()에서 DataRequest의 urlRequest를 반환해야하는데 nil 반환")
      XCTAssertEqual(dataRequest?.convertible.urlRequest?.url, targetURL)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 10)
  }
  
  func testUserInfoAPIEndpoint_UpdateProfile함수를_통해_makeRequest함수_호출할때_AbsoluteURL이_정확한지_ShouldReturnEqual() {
    // Arrange
    let targetURL = URL(string: "http://localhost:8080/profile/upload?userId=13")
    let queryRequestDTO = UserIdReqeustDTO(userId: 13)
    let requestDTO = UserProfileRequestDTO(profile: "test1234")
    let endpoint = sut.updateProfile(withQuery: queryRequestDTO, body: requestDTO)
    var dataRequest: DataRequest?
    expectation = expectation(description: "UpdateProfile finish")
    
    // Act
    DispatchQueue.global().async { [unowned self] in
      dataRequest = try? endpoint.makeRequest(from: mockSession)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 10)
    
    // Assert
    XCTAssertNotNil(dataRequest, "UserInfoAPIEndpoint의 updateProfile(withQuery:body:)에서 DataRequest를 반환해야 하는데 nil 반환")
    XCTAssertNotNil(
      dataRequest?.convertible.urlRequest,
      "UserInfoAPIEndpoint의 updateProfile(withQuery:body:)에서 DataRequest의 urlRequest를 반환해야하는데 nil 반환")
    XCTAssertEqual(dataRequest?.convertible.urlRequest?.url, targetURL)
  }
  
  func testUserInfoAPIEndpoint_UpdateProfile함수를_통해_makeRequest함수_호출할때_bodyParam이_잘추가되었는지_ShouldReturnEqual() {
    // Arrange
    let targetURL = URL(string: "http://localhost:8080/profile/upload?userId=13")
    let queryRequestDTO = UserIdReqeustDTO(userId: 13)
    let requestDTO = UserProfileRequestDTO(profile: "test1234")
    let endpoint = sut.updateProfile(withQuery: queryRequestDTO, body: requestDTO)
    var dataRequest: DataRequest?
    let expectedJsonString = "profile=test1234"
    expectation = expectation(description: "UpdatePRofile finish")
    
    // Act
    DispatchQueue.global().async { [unowned self] in
      dataRequest = try? endpoint.makeRequest(from: mockSession)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 10)
    
    // Assert
    XCTAssertNotNil(dataRequest, "UserInfoAPIEndpoint의 updateProfile(withQuery:body:)에서 DataRequest를 반환해야 하는데 nil 반환")
    XCTAssertNotNil(
      dataRequest?.convertible.urlRequest,
      "UserInfoAPIEndpoint의 updateProfile(withQuery:body:)에서 DataRequest의 urlRequest를 반환해야하는데 nil 반환")
    let testData = dataRequest!.convertible.urlRequest!.httpBody!
    let testString = String(data: testData, encoding: .utf8) ?? "no"
    XCTAssertEqual(dataRequest?.convertible.urlRequest?.url, targetURL)
    XCTAssertEqual(testString, expectedJsonString)
  }
  
  func testUserInfoAPIEndpoint_SaveProfile함수를_통해_makeRequest함수_호출할때_AbsoluteURL이_정확한지_ShouldReturnSuccess() {
    // Arrange
    let targetURL = URL(string: "http://localhost:8080/profile/upload?userId=13")
    let queryRequestDTO = UserIdReqeustDTO(userId: 13)
    let requestDTO = UserProfileRequestDTO(profile: "test1234")
    let endpoint = sut.saveProfile(withQuery: queryRequestDTO, body: requestDTO)
    var dataRequest: DataRequest?
    expectation = expectation(description: "saveProfile finish")
    
    // Act
    DispatchQueue.global().async { [unowned self] in
      dataRequest = try? endpoint.makeRequest(from: mockSession)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 10)
    
    // Assert
    XCTAssertNotNil(dataRequest, "UserInfoAPIEndpoint의 saveProfile(withQuery:body:)에서 DataRequest를 반환해야 하는데 nil 반환")
    XCTAssertNotNil(
      dataRequest?.convertible.urlRequest,
      "UserInfoAPIEndpoint의 saveProfile(withQuery:body:)에서 DataRequest의 urlRequest를 반환해야하는데 nil 반환")
    XCTAssertEqual(dataRequest?.convertible.urlRequest?.url, targetURL)
  }
  
  func testUserInfoAPIEndpoint_SaveProfile함수를_통해_makeRequest함수_호출할때_bodyParam이_잘추가되었는지_ShouldReturnEqual() {
    // Arrange
    let targetURL = URL(string: "http://localhost:8080/profile/upload?userId=13")
    let queryRequestDTO = UserIdReqeustDTO(userId: 13)
    let requestDTO = UserProfileRequestDTO(profile: "test1234")
    let endpoint = sut.saveProfile(withQuery: queryRequestDTO, body: requestDTO)
    var dataRequest: DataRequest?
    let expectedJsonString = "profile=test1234"
    expectation = expectation(description: "saveProfile finish")
    
    // Act
    DispatchQueue.global().async { [unowned self] in
      dataRequest = try? endpoint.makeRequest(from: mockSession)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 10)
    
    // Assert
    XCTAssertNotNil(dataRequest, "UserInfoAPIEndpoint의 saveProfile(withQuery:body:)에서 DataRequest를 반환해야 하는데 nil 반환")
    XCTAssertNotNil(
      dataRequest?.convertible.urlRequest,
      "UserInfoAPIEndpoint의 saveProfile(withQuery:body:)에서 DataRequest의 urlRequest를 반환해야하는데 nil 반환")
    let testData = dataRequest!.convertible.urlRequest!.httpBody!
    let testString = String(data: testData, encoding: .utf8) ?? "no"
    XCTAssertEqual(dataRequest?.convertible.urlRequest?.url, targetURL)
    XCTAssertEqual(testString, expectedJsonString)
  }

  func testUserInfoAPIEndpiont_DeleteProfile함수를_통해_makeRequest함수_호출할때_AbsoluteURL이_정확한지_ShouldReturnEqual() {
    // Arrange
    let targetURL = URL(string: "http://localhost:8080/profile?userId=13")
    let mockRequestDTO = UserIdReqeustDTO(userId: 13)
    let endpoint = sut.deleteProfile(with: mockRequestDTO)
    var dataRequest: DataRequest?
    let expectedJsonString = "profile=test1234"
    expectation = expectation(description: "saveProfile finish")
    
    // Act
    DispatchQueue.global().async { [unowned self] in
      dataRequest = try? endpoint.makeRequest(from: mockSession)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 10)
    
    // Assert
    XCTAssertNotNil(dataRequest, "UserInfoAPIEndpoint의 deleteProfile(with:)에서 DataRequest를 반환해야 하는데 nil 반환")
    XCTAssertNotNil(
      dataRequest?.convertible.urlRequest,
      "UserInfoAPIEndpoint의 deleteProfile(with:)에서 DataRequest의 urlRequest를 반환해야하는데 nil 반환")
    XCTAssertEqual(dataRequest?.convertible.urlRequest?.url, targetURL)
  }
  
  func testUserInfoAPIEndopint_fetchProfile함수를_통해_makeRequest함수_호출할때_AbsoluteURL이_정확한지_ShouldReturnEqual() {
    // Arrange
    let expectedURL = URL(string: "http://localhost:8080/profile/original?userId=13")
    let mockRequestDTO = UserIdReqeustDTO(userId: 13)
    let endpoint = sut.fetchProfile(with: mockRequestDTO)
    var dataRequest: DataRequest?
    expectation = expectation(description: "saveProfile finish")
    
    // Act
    DispatchQueue.global().async { [unowned self] in
      dataRequest = try? endpoint.makeRequest(from: mockSession)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 10)
    
    // Assert
    let resultURL = dataRequest?.convertible.urlRequest?.url
    XCTAssertNotNil(
      resultURL,
      "UserInfoAPIEndpoint의 fetchProfile(with:)에서 DataRequest의 urlRequest를 반환해야하는데 nil 반환")
    XCTAssertEqual(resultURL, expectedURL)
  }
}
