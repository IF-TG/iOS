//
//  ActivityIndicatorTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 4/11/24.
//

import XCTest
import Combine
@testable import travelPlan

final class ActivityIndicatorTests: XCTestCase {
  enum ViewModelState {
    case done
  }
  private var sut: ActivityIndicator!
  private var subscriptions: Set<AnyCancellable>!
  override func setUp() {
    super.setUp()
    sut = .init()
    subscriptions = .init()
  }
  
  override func tearDown() {
    super.tearDown()
   sut = nil
    subscriptions = .init()
  }
}

extension ActivityIndicatorTests {
  func test_WhenActivityIndicatorRelayIncreasedAndDecreased_ShouldReturnEqual() {
    // Arrange
    let subject = PassthroughSubject<Int, Never>()
    var activityStates: [ActivityIndicator.State] = []
    typealias State = ViewModelState
    let expectation = XCTestExpectation(description: "Activity state check")
    expectation.expectedFulfillmentCount = 3
    
    // Act
    subject.flatMap { [unowned self] value in
      sut.trackActivity()
      
      return Just(value + 100) // useCase etc...'s return publihser!!
        .delay(for: .seconds(2), scheduler: DispatchQueue.main)
        .releaseActivity(sut)
        .map { value -> State in
          return .done
        }.eraseToAnyPublisher()
    }.sink { state in
      print(state)
    }.store(in: &subscriptions)
    
    sut.loading.sink { state in
      print(state)
      switch state {
      case .begin:
        activityStates.append(state)
        expectation.fulfill()
      case .end:
        activityStates.append(state)
        expectation.fulfill()
      }
    }.store(in: &subscriptions)
    
    
    // Assert
    subject.send(10)
    wait(for: [expectation], timeout: 6)
    XCTAssertEqual(activityStates, [.end, .begin, .end])
  }
}
