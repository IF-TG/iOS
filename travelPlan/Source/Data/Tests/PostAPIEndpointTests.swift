//
//  PostAPIEndpointTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 3/7/24.
//

import XCTest
@testable import Alamofire
@testable import travelPlan

final class PostAPIEndpointTests: XCTestCase {
  
  typealias sut = PostAPIEndpoint
  let mockSession = MockSession.default
  var expectation: XCTestExpectation!
  let mockPage = Int32(1)
  let mockPerPage = Int32(5)
  var dataRequest: DataRequest?
  let baseURL = "http://localhost:8080/posts"
  
  override func setUp() {
    super.setUp()
    MockUrlProtocol.requestHandler = { _ in return ((HTTPURLResponse(), Data())) }
    expectation = expectation(description: "finish")
  }
  
  override func tearDown() {
    super.tearDown()
    expectation = nil
    dataRequest = nil
  }
  
  // MARK: - Tests
  func testPostAPIEndpoint_fetchPosts함수를통해_makeRequest호출시_AbsoluteURL이_정확한지_ShouldReturnEqual() {
    // Arrange
    let expectedURL = URL(string: "\(baseURL)?mainCategory=SEASON&orderMethod=RECENT_ORDER&page=0&perPage=20&subCategory=SPRING&userId=13")
    let mockRequestDTO = PostsRequestDTO(
      page: 0, perPage: 20, orderMethod: "RECENT_ORDER", mainCategory: "SEASON", subCategory: "SPRING", userId: 13)
    let endpoint = sut.fetchPosts(with: mockRequestDTO)
    
    // Act
    DispatchQueue.global(qos: .background).async { [unowned self] in
      dataRequest = try? endpoint.makeRequest(from: mockSession)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 10)
    
    // Assert
    XCTAssertNotNil(
      dataRequest?.convertible.urlRequest,
      "PostAPIEndpoint의 fetchPosts()에서 DataRequest의 urlRequest를 반환해야하는데 nil 반환")
    XCTAssertEqual(dataRequest?.convertible.urlRequest?.url, expectedURL)
  }
}

/// PostCategory에 담긴 정보 기반으로 reqeustDTO 생성 후 요청시 absoluteURL 이 정확히 반영되는지 테스트
/// CategoryMapper기반으로 PostCategory -> requestDTO로 변환.
extension PostAPIEndpointTests {
  
  /// subCategory가 nil인 경우 url 구성할 때 관련 key, value가 사라지는거 확인.
  func testPostAPIEndpoint_MainTheme_all타입_ReqeustDTO요청시_AbsoluteURL이_정확한지반영되는지_ShouldReturnTrue() {
    // Arrange
    let mockCategory = PostCategory(mainTheme: .all, orderBy: .newest)
    let mockRequestDTO = PostsRequestDTO.makeRequestDTO(
      page: mockPage, perPage: mockPerPage, category: mockCategory, userId: 1)
    let expectedURL = URL(string: "\(baseURL)?mainCategory=ORIGINAL&orderMethod=RECENT_ORDER&page=\(mockPage)&perPage=\(mockPerPage)&userId=1")
    let endpoint = sut.fetchPosts(with: mockRequestDTO)
    

    // Act
    makeRequest(fromFetchPosts: endpoint)
    
    // Assert
    XCTAssertNotNil(
      dataRequest?.convertible.urlRequest,
      "PostAPIEndpoint의 fetchPosts()에서 DataRequest의 urlRequest를 반환해야하는데 nil 반환")
    XCTAssertEqual(dataRequest?.convertible.urlRequest?.url, expectedURL)
  }
  
  func testPostAPIEndpoint_MainTheme_season_spring타입_RequestDTO요청시_AbsoluteURL이_정확히반영되는지_ShouldReturnTrue() {
    // Arrange
    let mockCategory = PostCategory(mainTheme: .season(.spring), orderBy: .newest)
    let mockRequestDTO = PostsRequestDTO.makeRequestDTO(
      page: mockPage, perPage: mockPerPage, category: mockCategory, userId: 1)
    let expectedURL = URL(string: "\(baseURL)?mainCategory=SEASON&orderMethod=RECENT_ORDER&page=\(mockPage)&perPage=\(mockPerPage)&subCategory=SPRING&userId=1")
    let endpoint = sut.fetchPosts(with: mockRequestDTO)
    
    // Act
    makeRequest(fromFetchPosts: endpoint)
    
    // Assert
    XCTAssertNotNil(
      dataRequest?.convertible.urlRequest,
      "PostAPIEndpoint의 fetchPosts()에서 DataRequest의 urlRequest를 반환해야하는데 nil 반환")
    XCTAssertEqual(dataRequest?.convertible.urlRequest?.url, expectedURL)
  }
}

// MARK: - Private Helpers
private extension PostAPIEndpointTests {
  func makeRequest(
    fromFetchPosts endpoint: Endpoint<CommonDTO<[PostContainerResponseDTO]>>
  ) {
    DispatchQueue.global(qos: .background).async { [unowned self] in
      dataRequest = try? endpoint.makeRequest(from: mockSession)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 7)
  }
}
