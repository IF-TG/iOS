//
//  FirestorePostNestedCommentHeartRepositoryTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/10/24.
//

import XCTest
import Combine
@testable import travelPlan
@testable import SHFirestoreService

final class FirestorePostNestedCommentHeartRepositoryTests: XCTestCase {
  // MARK: - Properties
  var sut: PostNestedCommentHeartRepository!
  var expectation: XCTestExpectation!
  var subscriptions = Set<AnyCancellable>()
  let testPostId = "ABEB803F-DD54-41A4-B8BF-487A210BD1EC"
  let testCommentId = "12181109-6CDE-46E5-AD4F-04E824E89581"
  let testNestedCommentId = "941C554D-CB1E-4B7E-A749-9DA76E67D960"
  
  override func setUp() {
    super.setUp()
    let service = FirestoreService()
    
    sut = FirestorePostNestedCommentHeartRepository(
      service: service)
    
    expectation = XCTestExpectation(description: "Finish")
  }
  
  override func tearDown() {
    super.tearDown()
    expectation = nil
    subscriptions.removeAll()
  }
}

extension FirestorePostNestedCommentHeartRepositoryTests {
  func test_heartNestedComment호출시성공적으로반환값을받는지() {
    // Arrange
    var unexpectedError: Error?
    var hasReceivedResult: Bool = false
    
    // Act
    let taskPublisher = sut.heartNestedComment(
      with: testPostId, commentId: testCommentId,
      nestedCommentId: testNestedCommentId, userId: "testUser1234")
    sink(
      fromPublisher: taskPublisher,
      withExpectation: expectation) { error, result in
        unexpectedError = error
        hasReceivedResult = result
      }
    .store(in: &subscriptions)
    wait(for: [expectation], timeout: 7.777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchProfile")
    XCTAssertTrue(hasReceivedResult, "대댓글에 좋아요한 사용자가 추가된 후에 성공적으로 사용자 id를 받아야하지만 받지 못했습니다")
  }
}
