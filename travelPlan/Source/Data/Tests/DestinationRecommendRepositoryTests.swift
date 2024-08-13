//
//  DestinationRecommendRepositoryTests.swift
//  travelPlanTests
//
//  Created by SeokHyun on 8/8/24.
//

import XCTest
import Combine
@testable import travelPlan

final class DestinationRecommendRepositoryTests: BaseXCTestCase {
  // MARK: - Properties
  private var sut: JsonMockDestinationRecommendRepository!
  
  // MARK: - LifeCycle
  override func setUp() {
    super.setUp()
    sut = JsonMockDestinationRecommendRepository(backgroundQueue: .main)
    subscriptions.removeAll()
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
  }
}

// MARK: - Tests
extension DestinationRecommendRepositoryTests {
  func test_fetchRecommendationDestinationList호출시_entity를_반환하는지() {
    // Arrange
    
    // Act
    let actPublisher = sut.fetchRecommendationDestinationList()
    execute(fromPublisher: actPublisher).store(in: &subscriptions)
    wait(for: [expectation], timeout: 7.77)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchRecommendationDestinationList")
    XCTAssert(hasReceivedResult, notReceivedErrorMessage)
  }
}
