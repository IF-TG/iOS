//
//  DefaultTourCommonInfoRepositoryTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/2/24.
//

import XCTest
import Combine
@testable import travelPlan

final class DefaultTourCommonInfoRepositoryTests: XCTestCase {
  // MARK: - Properties
  var sut: TourCommonInfoRepository!
  var subscription: AnyCancellable?
  var expectation: XCTestExpectation!
  
  // MARK: - Lifecycle
  override func setUp() {
    super.setUp()
    
    let service = TourApiSessionProvider()
    sut = DefaultTourCommonInfoRepository(
      service: service,
      backgroundQueue: .global(qos: .userInitiated))
    expectation = XCTestExpectation(description: "Finish")
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    subscription = nil
    expectation = nil
  }
}

/// 실제 tour api를 활용하에 데이터를 요청하고 원하는 entity로 decodable 후 responseDTO로 받는지에 대한 테스트입니다.
extension DefaultTourCommonInfoRepositoryTests {
  func test_WhenFetchTourCommonInfo_ShouldReturnTrue() {
    // Arrange
    var result = false
    var unexpectedError: Error?
    
    // Act
    subscription = sut.fetchTourCommonInfo(contentId: 126508, numOfRows: 10, pageNo: 1)
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
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchTourCommonInfo")
    XCTAssertTrue(result, notReceivedErrorMessage)
  }
}
