//
//  FirestoreUserBlockRepositoryTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/18/24.
//

import XCTest
import Combine
@testable import travelPlan
@testable import SHFirestoreService

final class FirestoreUserBlockRepositoryTests: XCTestCase {
  // MARK: - Properties
  var sut: UserBlockRepository!
  var expectation: XCTestExpectation!
  var subscriptions = Set<AnyCancellable>()
  
  override func setUp() {
    super.setUp()
    let service = FirestoreService()
    let stubOwnerStorage = StubOwnerStorage()
    sut = FirestoreUserBlockRepository(service: service, ownerStorage: stubOwnerStorage)
    expectation = XCTestExpectation(description: "대댓글 관련 테스트 !!")
  }
  
  override func tearDown() {
    super.tearDown()
    expectation = nil
    subscriptions.removeAll()
  }
}

/// firestore 디비 보면서 테스트를 진행해야합니다,,
extension FirestoreUserBlockRepositoryTests {
  func test_blockUser호출시_사용자가차단되는지() {
    // Arrange
    var hasReceivedResult = false
    var unexpectedError: Error?
    // let userId = "testUserId123"
    
    // Act
    let blockUserPublisher = sut.blockUser(with: 1).receive(on: RunLoop.current)
    sink(fromPublisher: blockUserPublisher, withExpectation: expectation) { err, res in
      unexpectedError = err
      hasReceivedResult = res
    }.store(in: &subscriptions)
    wait(for: [expectation], timeout: 7.777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "blockUser")
    XCTAssert(hasReceivedResult, notReceivedErrorMessage)
  }
  
  func test_unblockUser호출시_차단된사용자가해제되는지() {
    // Arrange
    var hasReceivedResult = false
    var unexpectedError: Error?
    // let userId = "testUserId123"
    
    // Act
    let blockUserPublisher = sut.unblockUser(with: 1).receive(on: RunLoop.current)
    sink(fromPublisher: blockUserPublisher, withExpectation: expectation) { err, res in
      unexpectedError = err
      hasReceivedResult = res
    }.store(in: &subscriptions)
    wait(for: [expectation], timeout: 7.777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "unblockUser")
    XCTAssert(hasReceivedResult, notReceivedErrorMessage)
  }
  
  func test_fetchBlockedUsers호출시_차단된사용자리스트를받아오는지() {
    // Arrange
    var hasReceivedResult = false
    var unexpectedError: Error?
    
    // Act
    let blockUserPublisher = sut.fetchBlockedUsers().receive(on: RunLoop.current)
    sink(fromPublisher: blockUserPublisher, withExpectation: expectation) { err, res in
      unexpectedError = err
      hasReceivedResult = res
    }.store(in: &subscriptions)
    wait(for: [expectation], timeout: 7.777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "unblockUser")
    XCTAssert(hasReceivedResult, notReceivedErrorMessage)
  }
}
