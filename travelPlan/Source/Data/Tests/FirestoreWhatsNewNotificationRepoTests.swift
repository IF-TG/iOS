//
//  FirestoreWhatsNewNotificationRepoTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 6/17/24.
//

import XCTest
import Combine
import SHFirestoreService
@testable import travelPlan

final class FirestoreWhatsNewNotificationRepoTests: BaseXCTestCase {
  var sut: FirestoreWhatsNewNotificationRepository!
  
  override func setUp() {
    super.setUp()
    sut = FirestoreWhatsNewNotificationRepository(service: FirestoreService())
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
  }
  
  // MARK: - Test
  
  func test_whenFetchWhatsNewNotifications_ShouldReturnTrue() {
    // Arrange
    
    // Act
    let testPublisher = sut.fetchNotices()
    execute(fromPublisher: testPublisher).store(in: &subscriptions)
    wait(for: [expectation], timeout: 7.777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchNotices")
    XCTAssert(hasReceivedResult, notReceivedErrorMessage)
  }
}
