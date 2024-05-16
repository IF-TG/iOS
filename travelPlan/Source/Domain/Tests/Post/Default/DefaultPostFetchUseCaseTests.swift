//
//  DefaultPostFetchUseCaseTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/16/24.
//

import XCTest
import Combine
@testable import travelPlan

final class DefaultPostFetchUseCaseTests: XCTestCase {
  var sut: PostFetchUseCase!
  var mockRepository: PostRepository!
  var subscription: AnyCancellable?
  var expectation: XCTestExpectation!
  
  // MARK: - Lifecycle
  override func setUp() {
    super.setUp()
    mockRepository = MockPostRepository()
    sut = DefaultPostFetchUseCase(postRepository: mockRepository)
    expectation = XCTestExpectation(description: "Finish")
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    subscription = nil
    expectation = nil
  }
}

extension DefaultPostFetchUseCaseTests {
  func test_fetchFilteredPosts호출시_postContainer배열값을_받았는지_responseDTO검증_shouldReturnTrue() {
    // Arrange
    let mockCategory = PostCategory(mainTheme: .all, orderBy: .newest)
    let mockPostFetchRequestValue = PostFetchRequestValue(page: 0, perPage: 10, category: mockCategory)
    var result: Bool = false
    var unexpectedError: Error?
    
    // Act
    let sutPublisher = sut.fetchFilteredPosts(with: mockPostFetchRequestValue)
    subscription = sink(fromPublisher: sutPublisher, withExpectation: expectation) { err, res in
      unexpectedError = err
      result = res
    }
    wait(for: [expectation], timeout: 7)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchFilteredPosts")
    XCTAssertTrue(result, notReceivedErrorMessage)
  }
}
