//
//  DefaultTourIntroductionInfoRepositoryTests.swift
//  travelPlanTests
//
//  Created by SeokHyun on 5/8/24.
//

import XCTest
import Combine
@testable import travelPlan

final class DefaultTourIntroductionInfoRepositoryTests: XCTestCase {
  // MARK: - Properties
  var sut: DefaultTourIntroductionInfoRepository!
  var subscriptions: Set<AnyCancellable>!
  var expectation: XCTestExpectation!
  
  // MARK: - LifeCycle
  override func setUp() {
    super.setUp()
    sut = .init(service: SessionProvider())
    subscriptions = .init()
    expectation = .init(description: "비동기 호출 관리")
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    subscriptions.removeAll()
    expectation = nil
  }
}

extension DefaultTourIntroductionInfoRepositoryTests {
  func test_fetchFestival메소드_호출시_value로_IntroductionInfoFestivalEntity를_내려주면_shouldReturnTrue() {
    // Arrange
    var unexpectedError: Error?
    var receivedResult = false
    let tourContentId = TourContentId(contentId: 3114721, contentTypeId: 15)
    
    // Act
    sut.fetchFestival(tourContentId: tourContentId)
      .sink { [weak self] completion in
        if case let .failure(error) = completion {
          unexpectedError = error
          self?.expectation.fulfill()
        }
      } receiveValue: { [weak self] entity in
        print("entity: \(entity)")
        receivedResult = true
        self?.expectation.fulfill()
      }
      .store(in: &subscriptions)
    
    waitForExpectations(timeout: 10)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchFestival")
    XCTAssertTrue(receivedResult, "receiveValue가 들어와야하는데 들어오지 않음")
  }
}
