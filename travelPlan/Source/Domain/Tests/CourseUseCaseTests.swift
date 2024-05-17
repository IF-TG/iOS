//
//  CourseUseCaseTests.swift
//  travelPlanTests
//
//  Created by SeokHyun on 5/18/24.
//

import XCTest
import Combine
@testable import travelPlan

final class CourseUseCaseTests: XCTestCase {
  // MARK: - Properties
  var sut: CourseUseCase!
  var subscriptions: Set<AnyCancellable>!
  var expectation: XCTestExpectation!
  
  // MARK: - LifeCycle
  override func setUp() {
    super.setUp()
    sut = DefaultCourseUseCase(
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
    expectation = .init(description: "service 비동기 호출")
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
extension CourseUseCaseTests {
  func test_fetchCourseDetail메소드_호출시_receivedVAlue로_CourseEntity를_내려받는지() {
    // Arrange
    var unexpectedError: Error?
    var result = false
    let courseId = TourContentId(contentId: 1968948, contentTypeId: TourType.course.rawValue)
    
    // Act
    let actPublisher = sut.fetchCourseDetail(tourContentId: courseId)
    
    sink(
      fromPublisher: actPublisher,
      withExpectation: expectation) { error, receivedResult in
        unexpectedError = error
        result = receivedResult
      }
      .store(in: &subscriptions)
    
      wait(for: [expectation], timeout: 10)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchCourseDetail")
    XCTAssertTrue(result, "receivedValue로 CourseEntity를 받아야하는데, 받지 못함.")
  }
}

