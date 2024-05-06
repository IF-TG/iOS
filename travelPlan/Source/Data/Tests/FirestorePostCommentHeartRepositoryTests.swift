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
@testable import FirebaseFirestore

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
  
  func test_hateComment호출시성공적으로파이어스토어에서좋아요한사용자가제거되며값을반환하는지() {
    // Arrange
    var hasReceivedResult = false
    var unexpectedError: Error?
    
    // Act
    sut.hateComment(with: testPostId, commentId: testCommentId, userId: testUserId)
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
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "hateComment")
    XCTAssertTrue(hasReceivedResult, "좋아요한 사용자가 파이어스토어에 성공적으로 제거된 후 빈 값을 반환해야하지만 예상치 못한 동작이 발생됬습니다")
  }
  
  func test_fetchCommentHearts호출시_성공저으로값을반환하는지() {
    // Arrange
    let prevExpectation = expectation(description: "사전 준비 작업")
    var receivedCommentHearts: Int?
    var expectedCommentHearts: Int?
    var unexpectedError: Error?
    Firestore.firestore()
      .collection("posts")
      .document(testPostId)
      .collection("comments")
      .document(testCommentId)
      .collection("comment-hearts")
      .getDocuments()
      .sink {
        if case .failure = $0 {
          XCTAssert(false, "testComment를 좋아한 사용자 개수를 받아오는 사전 작업에서 에러가 발생됬습니다.")
        }
      } receiveValue: { snapshot in
        expectedCommentHearts = snapshot.documents.count
        prevExpectation.fulfill()
      }.store(in: &subscriptions)
    wait(for: [prevExpectation], timeout: 7.777)
    
    // Act
    sut.fetchCommentHearts(with: testPostId, commentId: testCommentId)
      .sink { completion in
        if case .failure(let error) = completion {
          unexpectedError = error
          self.expectation.fulfill()
        }
      } receiveValue: { result in
        receivedCommentHearts = result
        self.expectation.fulfill()
      }.store(in: &subscriptions)
    
    wait(for: [expectation], timeout: 7.777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchCommentHearts")
    XCTAssertEqual(expectedCommentHearts, receivedCommentHearts, "예상된 좋아요 사용자 개수와 실제로 sut.fetchCommentHearts에서 받아오는 데이터가 일치해야하지만 일치하지 않습니다.")
  }
}
