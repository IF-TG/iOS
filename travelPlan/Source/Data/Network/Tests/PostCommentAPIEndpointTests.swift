//
//  PostCommentAPIEndpointTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 3/23/24.
//

import XCTest
@testable import travelPlan
@testable import Alamofire

final class PostCommentAPIEndpointTests: XCTestCase {
  typealias sut = PostCommentAPIEndpoint
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
  
  func testPostCommentAPIEndpoint_sendComment함수호출시_DataRequest과AbsoluteURL이_정확한지_ShouldReturnEqual() {
    // Arrange
    let expectedURL = URL(string: "http://localhost:8080/comment")
    let mockRequestDTO = PostCommentSendingRequestDTO(postId: Int64(1), comment: "테스트중..")

    let endpoint = sut.sendComment(with: mockRequestDTO)
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
      "PostAPIEndpoint의 sendComment()에서 DataRequest의 urlRequest를 반환해야하는데 nil 반환")
    XCTAssertEqual(dataRequest?.convertible.urlRequest?.url, expectedURL)
  }
  
  func testPostCommentAPIEndpoint_updateComment함수호출시_DataRequest과AbsoluteURL이_정확한지_ShouldReturnEqual() {
    // Arrange
    let expectedURL = URL(string: "http://localhost:8080/comment")
    let mockRequestDTO = PostCommentUpdateRequestDTO(commentId: 1, comment: "testtest")
    
    let endpoint = sut.updateComment(with: mockRequestDTO)
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
      "PostAPIEndpoint의 updateComment()에서 DataRequest의 urlRequest를 반환해야하는데 nil 반환")
    XCTAssertEqual(dataRequest?.convertible.urlRequest?.url, expectedURL)
  }
  
  func testPostCommentAPIEndpoint_deleteComment함수호출시_DataRequest과AbsoluteURL이_정확한지_ShouldReturnEqual() {
    // Arrange
    let expectedURL = URL(string: "http://localhost:8080/comment?commentId=1")
    let mockRequestDTO = PostCommentDeleteRequestDTO(commentId: 1)
    
    let endpoint = sut.deleteComment(with: mockRequestDTO)
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
      "PostAPIEndpoint의 deleteComment()에서 DataRequest의 urlRequest를 반환해야하는데 nil 반환")
    XCTAssertEqual(dataRequest?.convertible.urlRequest?.url, expectedURL)
  }
  
  func testPostCommentAPIEndpoint_fetchComments함수호출시_DataRequet과AbsoulteURL이_정확한지_ShouldReturnEqual() {
    // Arrange
    let expectedURL = URL(string: "http://localhost:8080/comment?page=3&perPage=3&postId=111111")
    let mockRequestDTO = PostCommentsRequestDTO(page: 3, perPage: 3, postId: 111111)
    
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
  
  func testPostCommentAPIEndpoint_toggleCommentHeart함수호출시_DataRequet과AbsoulteURL이_정확한지_ShouldReturnEqual() {
    // Arrange
    let expectedURL = URL(string: "http://localhost:8080/comment/like")
    let mockRequestDTO = PostCommentHeartToggleRequestDTO(id: 111)
    
    let endpoint = sut.toggleCommentHeart(with: mockRequestDTO)
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
      "PostAPIEndpoint의 toggleCommentHeart()에서 DataRequest의 urlRequest를 반환해야하는데 nil 반환")
    XCTAssertEqual(dataRequest?.convertible.urlRequest?.url, expectedURL)
  }
}
