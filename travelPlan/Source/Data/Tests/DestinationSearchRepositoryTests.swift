//
//  DestinationSearchRepositoryTests.swift
//  travelPlanTests
//
//  Created by SeokHyun on 7/15/24.
//

import XCTest
@testable import travelPlan

final class DestinationSearchRepositoryTests: BaseXCTestCase {
  // MARK: - Properties
  private var sut: DestinationSearchRepository!
  
  // MARK: - LifeCycle
  override func setUp() {
    super.setUp()
    sut = JsonMockDestinationSearchRepository(backgroundQueue: .main)
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    subscriptions.removeAll()
  }
}

// MARK: - Tests
extension DestinationSearchRepositoryTests {
  func test_fetchDestinationList호출시_검색결과여행지썸네일리스트반환하는지() {
    // Arrange
    let keyword = "테스트 키워트"
    
    // Act
    let publisher = sut.fetchDestinationList(by: keyword, page: nil, perPage: nil)
    execute(fromPublisher: publisher).store(in: &subscriptions)
    wait(for: [expectation], timeout: 7.77)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchDestinationList")
    XCTAssert(hasReceivedResult, notReceivedErrorMessage)
  }
}

