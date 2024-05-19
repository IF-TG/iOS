//
//  CultureFacilityUseCaseTests.swift
//  travelPlanTests
//
//  Created by SeokHyun on 5/16/24.
//

import XCTest
import Combine
@testable import travelPlan

final class CultureFacilityUseCaseTests: XCTestCase {
  // MARK: - Properties
  private var sut: CultureFacilityUseCase!
  private var subscriptions: Set<AnyCancellable>!
  private var expectation: XCTestExpectation!
  
  // MARK: - LifeCycle
  override func setUp() {
    super.setUp()
    sut = DefaultCultureFacilityUseCase(
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
    subscriptions = .init()
    expectation = .init()
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    subscriptions = nil
    expectation = nil
  }
}

// MARK: - Tests
extension CultureFacilityUseCaseTests {
  func test_fetchCultureFacilityDetail메소드_호출시_value로_CultureFacilityEntity를_받는지() {
    // Arrange
    var unexpectedError: Error?
    var result = false
    let cultureFacilityId = TourContentId(contentId: 2732489, contentTypeId: TourType.cultureFacility.rawValue)
    
    // Act
    let actPublisher = sut.fetchCultureFacilityDetail(tourContentId: cultureFacilityId)
    sink(
      fromPublisher: actPublisher,
      withExpectation: expectation) { error, receivedResult in
        unexpectedError = error
        result = receivedResult
      }
      .store(in: &subscriptions)
    
    wait(for: [expectation], timeout: 10)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchCultureFacility")
    XCTAssertTrue(result, "receivedValue로 CultureFacilityEntity를 받아야하는데, 받지 못함.")
  }
}
