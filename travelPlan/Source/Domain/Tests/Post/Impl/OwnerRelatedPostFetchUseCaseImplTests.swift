//
//  OwnerRelatedPostFetchUseCaseImplTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/17/24.
//

import XCTest
import Combine
@testable import travelPlan

final class OwnerRelatedPostFetchUseCaseImplTests: XCTestCase {
  var sut: OwnerRelatedPostFetchUseCaseImpl!
  var subscription: AnyCancellable?
  var expectation: XCTestExpectation!
  
  // MARK: - Lifecycle
  override func setUp() {
    super.setUp()
    
    sut = OwnerRelatedPostFetchUseCaseImpl(
      postAtomicRepository: StubPostFetchAtomicRepository(),
      ownerHeartPostRepository: StubOwnerHeartPostRepository(),
      userProfileRepository: StubUserProfileRepository(),
      ownerRepository: DefaultLoggedInUserRepository(storage: StubOwnerStorage()))
    expectation = XCTestExpectation(description: "테스트 시작!")
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    subscription = nil
    expectation = nil
  }
}

extension OwnerRelatedPostFetchUseCaseImplTests {
  func test_fetchOwnerLikedPosts호출시_조합된entity를성공적으로받는지() {
    // Arrange
    var receivedResult = false
    var unexpectedError: Error?
    
    // Act
    let sutPublisher = sut.fetchOwnerLikedPosts(page: 1, perPage: 5).receive(on: RunLoop.current)
    subscription = sink(fromPublisher: sutPublisher, withExpectation: expectation) { error, result in
      receivedResult = result
      unexpectedError = error
    }
    wait(for: [expectation], timeout: 7.777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchOwnerLikedPosts")
    XCTAssert(receivedResult, notReceivedErrorMessage)
  }
}
