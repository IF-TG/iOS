//
//  LeportsUseCaseTests.swift
//  travelPlanTests
//
//  Created by SeokHyun on 5/15/24.
//

import XCTest
import Combine
@testable import travelPlan

final class LeportsUseCaseTests: XCTestCase {
  // MARK: - Properties
  private var sut: LeportsUseCase!
  private var expectation: XCTestExpectation!
  private var subscriptions: Set<AnyCancellable>!
  
  // MARK: - LifeCycle
  override func setUp() {
    super.setUp()
    
    sut = DefaultLeportsUseCase(
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
    
    expectation = .init(description: "DefaultLeportsUseCase 테스트")
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
extension LeportsUseCaseTests {
  func test_fetchLeportsDetail메소드호출시_receivedValue로_LeportsEntity가_내려오는지() {
    // Arrange
    var unexpectedError: Error?
    var result = false
    let leportsId = TourContentId(contentId: 2994101, contentTypeId: TourType.leports.rawValue)
    
    // Act
    let leportsPublisher = sut.fetchLeportsDetail(tourContentId: leportsId)
    
    sink(
      fromPublisher: leportsPublisher,
      withExpectation: expectation) { error, receivedResult in
        unexpectedError = error
        result = receivedResult
      }
      .store(in: &subscriptions)
    
    wait(for: [expectation], timeout: 10)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchLeportsDetail")
    XCTAssertTrue(result, "receivedValue로 LeportsEntity를 받아야하는데 받지 못함.")
  }
}
