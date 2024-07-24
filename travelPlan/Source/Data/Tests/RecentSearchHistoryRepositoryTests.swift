//
//  RecentSearchHistoryRepositoryTests.swift
//  travelPlanTests
//
//  Created by SeokHyun on 7/24/24.
//

import XCTest
@testable import travelPlan

final class RecentSearchHistoryRepositoryTests: BaseXCTestCase {
  // MARK: - Properties
  private var sut: RecentSearchHistoryRepository!
  
  // MARK: - LifeCycle
  override func setUp() {
    super.setUp()
    sut = JsonMockRecentSearchHistoryRepository(dispatchQueue: .main)
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    subscriptions.removeAll()
  }
}

// MARK: - Tests
extension RecentSearchHistoryRepositoryTests {
  func test_fetchRecentSearchHistory시_최근검색객체배열을_받아오는지() {
    // Arrange
    let page: Int? = nil
    let perPage: Int? = nil
    
    // Act
    let actPublisher = sut.fetchRecentSearchHistory(page: page, perPage: perPage)
    execute(fromPublisher: actPublisher).store(in: &subscriptions)
    wait(for: [expectation], timeout: 7.77)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchRecentSearchHistory")
    XCTAssert(hasReceivedResult, notReceivedErrorMessage)
  }
}
