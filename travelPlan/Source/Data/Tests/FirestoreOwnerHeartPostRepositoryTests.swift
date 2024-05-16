//
//  FirestoreOwnerHeartPostRepositoryTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/16/24.
//

import XCTest
import Combine
@testable import SHFirestoreService
@testable import travelPlan

final class FirestoreOwnerHeartPostRepositoryTests: XCTestCase {
  let sut = FirestoreOwnerHeartPostRepository(
    ownerStorage: MockUserStorage(),
    service: FirestoreService())
  var expectation: XCTestExpectation!
  
  var subscriptions: Set<AnyCancellable> = []

  override func setUp() {
    super.setUp()
    subscriptions = Set<AnyCancellable>()
    expectation = XCTestExpectation(description: "테스트 시작합니다")
  }
  
  override func tearDown() {
    super.tearDown()
    subscriptions.removeAll()
  }
}

// MARK: 이 테스트는 firestore 보고 판별해야합니다.
extension FirestoreOwnerHeartPostRepositoryTests {
  func test_fetchOwnerHeartPostIdentifiers호출시_저장된포스트가담겨져오는지() {
    // Arrange
    var receivedResult = false
    var unexpectedError: Error?
    
    // Act
    let sutPublisher = sut.fetchOwnerHeartPostIdentifiers().receive(on: DispatchQueue.main)
    sink(fromPublisher: sutPublisher, withExpectation: expectation) { error, result in
      unexpectedError = error
      receivedResult = result
    }.store(in: &subscriptions)
    wait(for: [expectation], timeout: 7.777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchOwnerHeartPostIdentifiers")
    XCTAssertTrue(receivedResult)
  }
  
  func test_hasOwnerHeartPost호출시사용자가좋아한포스트가있는지() {
    // Arrange
    var receivedResult = false
    var unexpectedError: Error?
    
    // Act
    let sutPublisher = sut.hasOwnerHeartPost(postId: "testPost1").receive(on: DispatchQueue.main)
    sink(fromPublisher: sutPublisher, withExpectation: expectation) { error, result in
      unexpectedError = error
      receivedResult = result
    }.store(in: &subscriptions)
    wait(for: [expectation], timeout: 7.777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchOwnerHeartPostIdentifiers")
    XCTAssertTrue(receivedResult)

  }
}
