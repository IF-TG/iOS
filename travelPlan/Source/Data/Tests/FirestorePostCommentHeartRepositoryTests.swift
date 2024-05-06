//
//  FirestorePostCommentHeartRepositoryTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/6/24.
//

import XCTest
import Combine

@testable import travelPlan
@testable import SHFirestoreService

final class FirestorePostCommentHeartRepositoryTests: XCTestCase {
  var sut = {
    return FirestorePostCommentHeartRepository(
      service: FirestoreService(backgroundQueue: .main),
      backgroundQueue: .main)
  }()
  var expectation: XCTestExpectation!
  var subscriptions = Set<AnyCancellable>()
  let testPostId = "ABEB803F-DD54-41A4-B8BF-487A210BD1EC"
  let testCommentId = "testComment1"
  let testUserId = "testUser1"
  
  override func setUp() {
    super.setUp()
    expectation = XCTestExpectation(description: "테스트 시작")
  }
  
  override func tearDown() {
    super.tearDown()
    expectation = nil
    subscriptions.removeAll()
  }
}

extension FirestorePostCommentHeartRepositoryTests {
  func test_heartComment호출시성공적으로동작되는지() {
    // Arrange
    var hasReceivedResult = false
    var unexpectedError: Error?

    // Act
    sut.heartComment(with: testPostId, commentId: testCommentId, userId: testUserId)
      .sink { completion in
        if case .failure(let error) = completion {
          unexpectedError = error
          self.expectation.fulfill()
        }
      } receiveValue: { _ in
        hasReceivedResult = true
        self.expectation.fulfill()
      }.store(in: &subscriptions)
    
    wait(for: [expectation], timeout: 7.777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "heartComment")
    XCTAssertTrue(hasReceivedResult, "좋아요한 사용자가 파이어스토어에 성공적으로 등록된 후 빈 값을 반환해야하지만 예상치 못한 동작이 발생됬습니다")
  }
}
