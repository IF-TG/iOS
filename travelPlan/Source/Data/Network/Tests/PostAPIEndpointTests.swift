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
  func testPostAPIEndpoint_fetchPosts함수를통해_makeRequest호출시_AbsoluteURL이_정확한지_ShouldReturnEqual() {
    // Arrange
    let expectedURL = URL(string: "http://localhost:8080/posts?mainCategory=SEASON&orderMethod=RECENT_ORDER&page=0&perPage=20&subCategory=SPRING&userId=13")
    let mockRequestDTO = PostsRequestDTO(
      page: 0, perPage: 20, orderMethod: "RECENT_ORDER", mainCategory: "SEASON", subCategory: "SPRING", userId: 13)
    let endpoint = sut.fetchPosts(with: mockRequestDTO)
    var dataRequest: DataRequest?
    
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

// MARK: - PostAPIEndpoint.fetchComments test
extension PostAPIEndpointTests {
  func testPostAPIEndpoint_FetchPosts함수_makeRequest호출시_AbsoluteURL이_정확한지_ShouldReturnEqual() {
    // Arrange
    let expectedURL = URL(string: "http://localhost:8080/post/detail?page=1&perPage=5&postId=1")
    let mockRequestDTO = PostCommentsRequestDTO(page: 1, perPage: 5, postId: 1)
    
    let endpoint = sut.fetchComments(with: mockRequestDTO)
    var dataRequest: DataRequest?
    
    // Act
    DispatchQueue.global(qos: .background).async { [unowned self] in
      dataRequest = try? endpoint.makeRequest(from: mockSession)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 10)
    
    // Assert
    XCTAssertNotNil(
      dataRequest?.convertible.urlRequest,
      "PostAPIEndpoint의 fetchComments()에서 DataRequest의 urlRequest를 반환해야하는데 nil 반환")
    XCTAssertEqual(dataRequest?.convertible.urlRequest?.url, expectedURL)
  }
}
