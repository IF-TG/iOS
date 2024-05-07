//
//  DefaultTourFestivalInfoRepositoryTests.swift
//  travelPlanTests
//
//  Created by SeokHyun on 5/7/24.
//

import XCTest
import Combine
@testable import travelPlan

final class DefaultTourFestivalInfoRepositoryTests: XCTestCase {
  // MARK: - Properties
  var sut: DefaultTourFestivalInfoRepository!
  var expectation: XCTestExpectation!
  var subscriptions: Set<AnyCancellable>!
  
  // MARK: - LifeCycle
  override func setUp() {
    super.setUp()
    sut = DefaultTourFestivalInfoRepository(service: SessionProvider())
    expectation = .init(description: "비동기 호출 관리")
    subscriptions = .init()
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    subscriptions.removeAll()
  }
}

// MARK: - Tests
extension DefaultTourFestivalInfoRepositoryTests {
  func test_fetchFestivalList함수_호출시_value로FestivalThumbnailEntity배열을보내주면ShouldReturnTrue() {
    // Arrange
    var unexpectedError: Error?
    var receivedResult = false
    
    // Act
    sut.fetchFestivalList()
      .sink { [weak self] completion in
        if case let .failure(error) = completion {
          unexpectedError = error
          self?.expectation.fulfill()
        }
      } receiveValue: { [weak self] values in
        receivedResult = true
        self?.expectation.fulfill()
      }
      .store(in: &subscriptions)
    
    wait(for: [expectation], timeout: 10)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchFestivalList")
    XCTAssertTrue(receivedResult, "receivedValue가 들어와야 하는데 들어오지 않음")
  }
}
