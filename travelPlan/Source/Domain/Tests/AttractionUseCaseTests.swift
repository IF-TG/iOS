//
//  AttractionUseCaseTests.swift
//  travelPlanTests
//
//  Created by SeokHyun on 5/15/24.
//

import XCTest
import Combine
@testable import travelPlan

final class AttractionUseCaseTests: XCTestCase {
  // MARK: - Properties
  private var sut: AttractionUseCase!
  private var expectation: XCTestExpectation!
  private var subscriptions: Set<AnyCancellable>!
  
  // MARK: - LifeCycle
  override func setUp() {
    super.setUp()
    sut = DefaultAttractionUseCase(
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
extension AttractionUseCaseTests {
  func test_fetchAttractionDetail메소드_호출시_receivedValue로_AttractionEntity받는지() {
    // Arrange
    var unexpectedError: Error?
    var result = false
    let attractionId = TourContentId(contentId: 2019720, contentTypeId: TourType.attraction.rawValue)
    
    // Act
    let actPublisher = sut.fetchAttraction(tourContentId: attractionId)
    sink(
      fromPublisher: actPublisher,
      withExpectation: expectation
    ) { error, receivedResult in
      unexpectedError = error
      result = receivedResult
    }
    .store(in: &subscriptions)
    
    wait(for: [expectation], timeout: 10)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchAttraction")
    XCTAssertTrue(result, "receivedValue로 AttractionEntity를 받아야하는데 받지 못함.")
  }
}
