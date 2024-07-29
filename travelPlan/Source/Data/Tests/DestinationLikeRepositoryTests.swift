//
//  DestinationLikeRepositoryTests.swift
//  travelPlanTests
//
//  Created by SeokHyun on 7/24/24.
//

import XCTest
@testable import travelPlan

final class DestinationLikeRepositoryTests: BaseXCTestCase {
  // MARK: - Properties
  private var sut: DestinationLikeRepository!
  
  // MARK: - LifeCycle
  override func setUp() {
    super.setUp()
    sut = JsonMockDestinationLikeRepository(backgroundQueue: .main)
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    subscriptions.removeAll()
  }
}

// MARK: - Tests
extension DestinationLikeRepositoryTests {
  func test_toggleDestinationLike시_엔터티를_반환하는지() {
    // Arrange
    let destinationId = 123
    
    // Act
    let actPublisher = sut.toggleDestinationLike(destinationId: destinationId)
    execute(fromPublisher: actPublisher).store(in: &subscriptions)
    wait(for: [expectation], timeout: 7.77)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "toggleDestinationLike")
    XCTAssert(hasReceivedResult, notReceivedErrorMessage)
  }
}
