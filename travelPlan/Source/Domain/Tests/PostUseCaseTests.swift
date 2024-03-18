//
//  PostUseCaseTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 3/8/24.
//

import XCTest
import Combine
@testable import travelPlan

final class PostUseCaseTests: XCTestCase {
  // MARK: - Properties
  var sut: PostUseCase!
  var mockRepository: PostRepository!
  var subscription: AnyCancellable?
  var expectation: XCTestExpectation!
  
  // MARK: - Lifecycle
  override func setUp() {
    super.setUp()
    mockRepository = MockPostRepository()
    sut = DefaultPostUseCase(postRepository: mockRepository)
    expectation = XCTestExpectation(description: "Finish")
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    subscription = nil
    expectation = nil
  }
  
  // MARK: - Tests
  func testPostUseCase_fetchPosts함수를통해_postContainer배열값을_받았는지_responseDTO검증_shouldReturnTrue() {
    // Arrange
    let mockPostsPage = PostsPage(page: 1, perPage: 1, category: .init(mainTheme: .all, orderBy: .newest), posts: [])
    var result = false
    var unexpectedError: MainError?
    
    // Act
    subscription = sut.postContainers
      .sink(receiveCompletion: { [unowned self] completion in
        if case .failure(let error) = completion { unexpectedError = error }
        result = false
        expectation.fulfill()
      }, receiveValue: { [unowned self] postContainers in
        print("DEBUG: 값을 성공적으로 받음\n\(postContainers.description)")
        result = true
        expectation.fulfill()
      })
    
    sut.fetchPosts(with: mockPostsPage)
    wait(for: [expectation], timeout: 7)
    
    // Assert
    if let unexpectedError {
      XCTAssert(
        false,
        """
          testPostUseCase의 fetchPosts()를 호출했을 때 postContainer값을 성공적으로 받아야 하지만 에러가 발생됨
          Error description:\(unexpectedError.description)
        """)
    }
    
    XCTAssertTrue(
      result,
      "testPostUseCase의 fetchPosts()를 호출했을 때 postContainer값을 받아야하지만, 퍼블리셔의 upstream이 종료됨")
  }
}
