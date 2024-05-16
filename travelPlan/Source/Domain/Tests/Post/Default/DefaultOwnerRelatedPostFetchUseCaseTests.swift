//
//  DefaultOwnerRelatedPostFetchUseCaseTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/16/24.
//

import XCTest
import Combine
@testable import travelPlan

final class DefaultOwnerRelatedPostFetchUseCaseTests: XCTestCase {
  var sut: OwnerRelatedPostFetchUseCase!
  var mockRepository: PostRepository!
  var subscription: AnyCancellable?
  var expectation: XCTestExpectation!
  
  // MARK: - Lifecycle
  override func setUp() {
    super.setUp()
    mockRepository = MockPostRepository()
    sut = DefaultOwnerRelatedPostFetchUseCase(postRepository: mockRepository)
    expectation = XCTestExpectation(description: "Finish")
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    subscription = nil
    expectation = nil
  }
}

extension DefaultOwnerRelatedPostFetchUseCaseTests {
  func test_fetchLikedPostsByLoggedInUser함수를통해_postContainer배열값을_받았는지_responseDTO검증_shouldReturnTrue() {
    // Arrange
    var result: Bool = false
    var unexpectedError: Error?
    
    // Act
    let sutPublisher = sut.fetchOwnerLikedPosts(page: 1, perPage: 5)
    subscription = sink(fromPublisher: sutPublisher, withExpectation: expectation) { err, res in
      unexpectedError = err
      result = res
    }
    wait(for: [expectation], timeout: 7)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchOwnerLikedPosts")
    XCTAssertTrue(result, notReceivedErrorMessage)
  }
}
