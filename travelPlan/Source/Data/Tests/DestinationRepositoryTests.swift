//
//  DestinationRepositoryTests.swift
//  travelPlanTests
//
//  Created by SeokHyun on 7/29/24.
//

import XCTest
@testable import travelPlan

final class DestinationRepositoryTests: BaseXCTestCase {
  // MARK: - Properties
  private var sut: JsonMockDestinationRepository!
  
  // MARK: - LifeCycle
  override func setUp() {
    super.setUp()
    sut = JsonMockDestinationRepository(backgroundQueue: .main)
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    subscriptions.removeAll()
  }
}

extension DestinationRepositoryTests {
  /// 1. festival
  func test_fetchDestination_호출시_festival엔터티를_반환하는지() {
    // Arrange
    let testId = 1
    let testContentTypeId = TourType.festival.rawValue
    let mockResponseType = MockResponseType.GetDestination.festival
    
    // Act
    let actPublisher = sut.fetchDestination(
      destinationId: .init(id: testId, contentTypeId: testContentTypeId), 
      mockResponseType: mockResponseType
    )
    execute(fromPublisher: actPublisher).store(in: &subscriptions)
    wait(for: [expectation], timeout: 7.77)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchDestination")
    XCTAssert(hasReceivedResult, notReceivedErrorMessage)
  }
  
  /// 2. restaurant
  func test_fetchDestination_호출시_restaurant엔터티를_반환하는지() {
    // Arrange
    let testId = 1
    let testContentTypeId = TourType.restaurant.rawValue
    let mockResponseType = MockResponseType.GetDestination.restaurant
    
    // Act
    let actPublisher = sut.fetchDestination(
      destinationId: .init(id: testId, contentTypeId: testContentTypeId),
      mockResponseType: mockResponseType
    )
    execute(fromPublisher: actPublisher).store(in: &subscriptions)
    wait(for: [expectation], timeout: 7.77)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchDestination")
    XCTAssert(hasReceivedResult, notReceivedErrorMessage)
  }
  
  /// 3. attraction
  func test_fetchDestination_호출시_attraction엔터티를_반환하는지() {
    // Arrange
    let testId = 1
    let testContentTypeId = TourType.attraction.rawValue
    let mockResponseType = MockResponseType.GetDestination.attraction
    
    // Act
    let actPublisher = sut.fetchDestination(
      destinationId: .init(id: testId, contentTypeId: testContentTypeId),
      mockResponseType: mockResponseType
    )
    execute(fromPublisher: actPublisher).store(in: &subscriptions)
    wait(for: [expectation], timeout: 7.77)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchDestination")
    XCTAssert(hasReceivedResult, notReceivedErrorMessage)
  }
  
  /// 4. leports
  func test_fetchDestination_호출시_leports엔터티를_반환하는지() {
    // Arrange
    let testId = 1
    let testContentTypeId = TourType.leports.rawValue
    let mockResponseType = MockResponseType.GetDestination.leports
    
    // Act
    let actPublisher = sut.fetchDestination(
      destinationId: .init(id: testId, contentTypeId: testContentTypeId),
      mockResponseType: mockResponseType
    )
    execute(fromPublisher: actPublisher).store(in: &subscriptions)
    wait(for: [expectation], timeout: 7.77)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchDestination")
    XCTAssert(hasReceivedResult, notReceivedErrorMessage)
  }
  
  /// 5. cultureFacility
  func test_fetchDestination_호출시_cultureFacility엔터티를_반환하는지() {
    // Arrange
    let testId = 1
    let testContentTypeId = TourType.cultureFacility.rawValue
    let mockResponseType = MockResponseType.GetDestination.cultureFacility
    
    // Act
    let actPublisher = sut.fetchDestination(
      destinationId: .init(id: testId, contentTypeId: testContentTypeId),
      mockResponseType: mockResponseType
    )
    execute(fromPublisher: actPublisher).store(in: &subscriptions)
    wait(for: [expectation], timeout: 7.77)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchDestination")
    XCTAssert(hasReceivedResult, notReceivedErrorMessage)
  }
  
  /// 6. shopping
  func test_fetchDestination_호출시_shopping엔터티를_반환하는지() {
    // Arrange
    let testId = 1
    let testContentTypeId = TourType.shopping.rawValue
    let mockResponseType = MockResponseType.GetDestination.shopping
    
    // Act
    let actPublisher = sut.fetchDestination(
      destinationId: .init(id: testId, contentTypeId: testContentTypeId),
      mockResponseType: mockResponseType
    )
    execute(fromPublisher: actPublisher).store(in: &subscriptions)
    wait(for: [expectation], timeout: 7.77)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchDestination")
    XCTAssert(hasReceivedResult, notReceivedErrorMessage)
  }
}
