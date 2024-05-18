//
//  RestaurantUseCaseTests.swift
//  travelPlanTests
//
//  Created by SeokHyun on 5/16/24.
//

import XCTest
import Combine
@testable import travelPlan

final class RestaurantUseCaseTests: XCTestCase {
  // MARK: - Properties
  private var expectation: XCTestExpectation!
  private var sut: RestaurantUseCase!
  private var subscriptions: Set<AnyCancellable>!
  
  // MARK: - LifeCycle
  override func setUp() {
    super.setUp()
    sut = DefaultRestaurantUseCase(
      tourIntroductionInfoRepository: DefaultTourIntroductionInfoRepository(
        service: TourApiSessionProvider(),
        backgroundQueue: DispatchQueue.main
      ),
      tourCommonInfoRepository: DefaultTourCommonInfoRepository(
        service: TourApiSessionProvider(),
        imageService: ImageSessionProvider(),
        backgroundQueue: DispatchQueue.main
      ),
      tourImageRetrieveInfoRepository: DefaultTourImageRetrieveInfoRepository(
        service: TourApiSessionProvider(),
        backgroundQueue: DispatchQueue.main
      )
    )
    expectation = .init()
    subscriptions = .init()
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    expectation = nil
    subscriptions = nil
  }
}

// MARK: - Tests
extension RestaurantUseCaseTests {
  func test_fetchRestaurantDetail메소드_호출시_receivedValue로_RestaurantEntity를_내려받는지() {
    // Arrange
    var unexpectedError: Error?
    var result = false
    let restaurantId = TourContentId(contentId: 2781914, contentTypeId: TourType.restaurant.rawValue)
    
    // Act
    let actPublisher = sut.fetchRestaurantDetail(tourContentId: restaurantId)
    
    sink(
      fromPublisher: actPublisher,
      withExpectation: expectation) { error, receivedResult in
        unexpectedError = error
        result = receivedResult
      }
      .store(in: &subscriptions)
    
      wait(for: [expectation], timeout: 10)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchRestaurantDetail")
    XCTAssertTrue(result, "receivedValue로 RestaurantEntity를 받아야하는데, 받지 못함.")
  }
}
