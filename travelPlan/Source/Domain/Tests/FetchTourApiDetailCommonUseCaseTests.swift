//
//  FetchTourApiDetailCommonUseCaseTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 4/20/24.
//

import XCTest
import Combine
@testable import travelPlan

final class FetchTourApiDetailCommonUseCaseTests: XCTestCase {
  // MARK: - Properties
  var sut: TourApiDetailCommonUseCase!
  var subscription: AnyCancellable?
  var expectation: XCTestExpectation!
  
  // MARK: - Lifecycle
  override func setUp() {
    super.setUp()
    
    let service = TourApiSessionProvider()
    let tourDestinationRepository = DefaultTourDetailCommonRepository(
      service: service,
      backgroundQueue: .global(qos: .userInitiated))
    sut = FetchTourApiDetailCommonUseCase(tourDestinationRepository: tourDestinationRepository)
    expectation = XCTestExpectation(description: "Finish")
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    subscription = nil
    expectation = nil
  }
}

/// 실제 tour api를 활용하에 데이터를 요청하고 원하는 entity로 decodable 후 entity로 받는지에 대한 테스트입니다.
extension FetchTourApiDetailCommonUseCaseTests {
  func test_WhenFetchTourDestinationDetailCommonInfo_ShouldReturnTrue() {
    // Arrange
    var result = false
    var unexpectedError: Error?
    
    // Act
    subscription = sut.fetchDetailCommonInfo(contentId: 126508, numOfRows: 10, pageNo: 1)
      .sink { [unowned self] completion in
        if case .failure(let error) = completion {
          unexpectedError = error
        }
        expectation.fulfill()
      } receiveValue: { [unowned self] entity in
        print("DEBUG: 값을 성공적으로 받음 (축하)(축하)\n\n:\(entity)\n")
        result = true
        expectation.fulfill()
      }
    wait(for: [expectation], timeout: 10)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchDetailCommonInfo")
    XCTAssertTrue(result, notReceivedErrorMessage)
  }
}
