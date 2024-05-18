//
//  AccommodationUseCaseTests.swift
//  travelPlanTests
//
//  Created by SeokHyun on 5/16/24.
//

import XCTest
import Combine
@testable import travelPlan

final class AccommodationUseCaseTests: XCTestCase {
  // MARK: - Properties
  private var expectation: XCTestExpectation!
  private var sut: AccommodationUseCase!
  private var subscriptions: Set<AnyCancellable>!
  
  // MARK: - LifeCycle
  override func setUp() {
    super.setUp()
    sut = DefaultAccommodationUseCase(
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
        imageService: ImageSessionProvider(),
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
extension AccommodationUseCaseTests {
  func test_fetchAccommodationDetail메소드_호출시_receivedVAlue로_AccommodationEntity를_내려받는지() {
    // Arrange
    var unexpectedError: Error?
    var result = false
    let accommodationId = TourContentId(contentId: 136605, contentTypeId: TourType.accommodation.rawValue)
    
    // Act
    let actPublisher = sut.fetchAccommodationDetail(tourContentId: accommodationId)
    
    sink(
      fromPublisher: actPublisher,
      withExpectation: expectation) { error, receivedResult in
        unexpectedError = error
        result = receivedResult
      }
      .store(in: &subscriptions)
    
      wait(for: [expectation], timeout: 10)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchAccommodationDetail")
    XCTAssertTrue(result, "receivedValue로 AccommodationEntity를 받아야하는데, 받지 못함.")
  }
}
