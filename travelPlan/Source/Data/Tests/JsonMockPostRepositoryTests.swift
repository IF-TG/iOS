//
//  JsonMockPostRepositoryTests.swift
//  travelPlanTests
//
//  Created by SeokHyun on 9/20/24.
//

import XCTest
import Combine
@testable import travelPlan

final class JsonMockPostRepositoryTests: XCTestCase {
  // MARK: - Properties
  private var sut: JsonMockPostRepository!
  private var subscriptions = Set<AnyCancellable>()
  private var expectation: XCTestExpectation!
  
  // MARK: - LifeCycle
  override func setUp() {
    super.setUp()
    sut = JsonMockPostRepository()
    expectation = XCTestExpectation(description: "finish")
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    expectation = nil
  }
}

// MARK: - Tests
extension JsonMockPostRepositoryTests {
  /// mock_response_postContainer.json 파일 response test
  func test_mockRespnose의_델리미터가_성공적으로_분리되는지() {
    // Arrange
    let dummyPage: Int32 = 10
    let dummyPerPage: Int32 = 10
    let dummyCategory = PostCategory(mainTheme: .all, orderBy: TravelOrderType.newest)
    // "텍트스하나1텍스트하나1490B4DE7-3173-4073-9DB7-44CD7D9F3F14텍스트둘2텍스트둘2FBD96749-154F-4ED1-8F74-40DBAB61624D0851DA83-0D1E-44AA-9924-1DF5321A2725텍스트삼3텍스트삼3"
    let desiredResult: [Post.PostContent] = [
      .init(sort: 1, text: "텍트스하나1텍스트하나1"),
      .init(sort: 3, text: "텍스트둘2텍스트둘2"),
      .init(sort: 6, text: "텍스트삼3텍스트삼3")
    ]
    var isEqualResult = false
    
    // Act
    sut.fetchPosts(page: dummyPage, perPage: dummyPerPage, category: dummyCategory)
      .sink { _ in
      } receiveValue: { [weak self] postPage in
        guard let firstPost = postPage.posts.first else { return }
        let result = firstPost.detail.content
        
        if result == desiredResult {
          isEqualResult.toggle()
        }
        self?.expectation.fulfill()
      }
      .store(in: &subscriptions)
    wait(for: [expectation], timeout: 7.77)
    
    // Assert
    XCTAssertTrue(isEqualResult)
  }
}
