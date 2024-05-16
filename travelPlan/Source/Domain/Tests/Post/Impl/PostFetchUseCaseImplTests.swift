//
//  PostFetchUseCaseImplTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/16/24.
//

import XCTest
import Combine
@testable import travelPlan

final class PostFetchUseCaseImplTests: XCTestCase {
  var sut: PostFetchUseCase!
  var subscription: AnyCancellable?
  var expectation: XCTestExpectation!
  
  // MARK: - Lifecycle
  override func setUp() {
    super.setUp()
    
    sut = PostFetchUseCaseImpl(
      postFetchAtomicRepository: StubPostFetchAtomicRepository(),
      userProfileRepository: StubUserProfileRepository(),
      postHeartRepository: StubPostHeartRepository(),
      ownerHeartPostRepository: StubOwnerHeartPostRepository())
    expectation = XCTestExpectation(description: "Finish")
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    subscription = nil
    expectation = nil
  }
 
  func test_fetchFilteredPosts함수호출시_성공적으로entity를받는지() {
    // Arrange
    var hasReceivedResult: Bool = false
    var unexpectedError: Error?
    let postCategory = PostCategory(mainTheme: .all, orderBy: .newest)
    let requestValue = PostFetchRequestValue(page: 1, perPage: 10, category: postCategory)
    
    // Act
    let filteredPostsFetchPublisher = sut.fetchFilteredPosts(with: requestValue)
    subscription = sink(fromPublisher: filteredPostsFetchPublisher, withExpectation: expectation) { err, res in
      hasReceivedResult = res
      unexpectedError = err
    }
    wait(for: [expectation], timeout: 7.777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchFilteredPosts")
    XCTAssertTrue(hasReceivedResult, notReceivedErrorMessage)
  }
}
