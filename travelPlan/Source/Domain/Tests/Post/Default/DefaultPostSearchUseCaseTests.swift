//
//  DefaultPostSearchUseCaseTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/16/24.
//

import XCTest
import Combine
@testable import travelPlan

final class DefaultPostSearchUseCaseTests: XCTestCase {
  var sut: PostSearchUseCase!
  var mockRepository: PostRepository!
  var subscription: AnyCancellable?
  var expectation: XCTestExpectation!
  
  // MARK: - Lifecycle
  override func setUp() {
    super.setUp()
    mockRepository = MockPostRepository()
    sut = DefaultPostSearchUseCase(postRepository: mockRepository)
    expectation = XCTestExpectation(description: "Finish")
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    subscription = nil
    expectation = nil
  }
  
  func test_searchPosts함수호출시_OutputValue로Entity받았는지_ShouldReturnTrue() {
    // Arrange
    var result = false
    var unexpectedError: Error?
    
    // Act
    let sutPublisher = sut.searchPosts(keyword: "가장 맛있는 국밥집", page: 1, perPage: 10, isTitle: false, isContent: true)
    subscription = sink(fromPublisher: sutPublisher, withExpectation: expectation) { err, res in
      unexpectedError = err
      result = res
    }
    wait(for: [expectation], timeout: 7.777777777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "searchPosts")
    XCTAssertTrue(result, notReceivedErrorMessage)
  }  
}
