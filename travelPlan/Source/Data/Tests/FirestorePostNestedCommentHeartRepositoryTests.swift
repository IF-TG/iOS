//
//  FirestorePostNestedCommentHeartRepositoryTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/10/24.
//

import XCTest
import Combine
@testable import FirebaseFirestore
@testable import travelPlan
@testable import SHFirestoreService

final class FirestorePostNestedCommentHeartRepositoryTests: XCTestCase {
  // MARK: - Properties
  var sut: PostNestedCommentHeartRepository!
  var expectation: XCTestExpectation!
  var subscriptions = Set<AnyCancellable>()
  // MARK: - Identifier
  // firestore의 identifer들은 String 입니다 하지만 spring server에서는 Int로 Identifier를 제공하고, 현재
  // spring server를 사용하기에 Int64숫자 임의대로 지정했습니다. 테스트는 결과는 전부 false됩니다...
  // target은 추가히지 않았습니다.
  //  let testPostId = "ABEB803F-DD54-41A4-B8BF-487A210BD1EC"
  //  let testCommentId = "12181109-6CDE-46E5-AD4F-04E824E89581"
  //  let testNestedCommentId = "941C554D-CB1E-4B7E-A749-9DA76E67D960"
  let testPostId: PostIdentifier = 1
  let testCommentId: CommentIdentifier = 1
  let testNestedCommentId: NestedCommentIdentifier = 1
  
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
      nestedCommentId: testNestedCommentId, userId: 1)
    sink(
      fromPublisher: taskPublisher,
      withExpectation: expectation) { error, result in
        unexpectedError = error
        hasReceivedResult = result
      }
    .store(in: &subscriptions)
    wait(for: [expectation], timeout: 7.777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "heartNestedComment")
    XCTAssertTrue(hasReceivedResult, "대댓글에 좋아요한 사용자가 추가된 후에 성공적으로 사용자 id를 받아야하지만 받지 못했습니다")
  }
  
  func test_hateNestedComment호출시성공적으로사용자가제거되는지() {
    // Arrange
    var unexpectedError: Error?
    var hasReceivedResult: Bool = false
    let testUserName: Int64 = 1
    var prevExpectation = expectation(description: "사전 준비작업으로 위에서 테스트한 함수가 사용됩니다")
    sut.heartNestedComment(
      with: testPostId, commentId: testCommentId, nestedCommentId: testNestedCommentId, userId: testUserName)
    .sink {
      if case .failure = $0 {
        XCTFail("대댓글 좋아요한 사용자 삭제 테스트하기 위해 사전작업으로 좋아요한 사용자 넣는 도중 에러 발생")
        prevExpectation.fulfill()
      }
    } receiveValue: { _ in
      prevExpectation.fulfill()
    }.store(in: &subscriptions)
    wait(for: [prevExpectation], timeout: 7.777)
    
    // Act
    let taskPublisher = sut.hateNestedComment(
      with: testPostId, commentId: testCommentId,
      nestedCommentId: testNestedCommentId, userId: testUserName)
    sink(
      fromPublisher: taskPublisher,
      withExpectation: expectation) { error, result in
        unexpectedError = error
        hasReceivedResult = result
      }.store(in: &subscriptions)
    wait(for: [expectation], timeout: 7.777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "hateNestedComment")
    XCTAssertTrue(hasReceivedResult, "대댓글 싫어요한 사용자가 삭제되야하지만 반환값을 받지 못했습니다")
  }
  
  func test_fetchNestedCommentUsers호출시대댓글좋아요한사용자들받아오는지() {
    // Arrange
    var unexpectedError: Error?
    var hasReceivedResult: Bool = false
    
    // Act
    let taskPublisher = sut.fetchNestedCommentHeartUsers(
      with: testPostId, commentId: testCommentId, nestedCommentId: testNestedCommentId)
    sink(fromPublisher: taskPublisher, withExpectation: expectation) { error, result in
      unexpectedError = error
      hasReceivedResult = result
    }.store(in: &subscriptions)
    wait(for: [expectation], timeout: 7.777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchNestedCommentHeartUsers")
    XCTAssertTrue(hasReceivedResult, "대댓글 좋아요한 사용자 리스트 불러오지 못했습니다")
  }
  
  /// 대댓글 필드 증가전, 증가 후 필드값을 디비에서 받아와야하지만 이번에는 디비직접보고.. 체크하도록 테스트했습니다,,
  func test_updateNestedCommentHearts호출시해당필드가증가되는가() {
    // Arrange
    var hasReceivedResult: Bool = false
    var unexpectedError: Error?
    
    
    // Act
    let taskPublisher = sut.updateNestedCommentHearts(
      with: testPostId, commentId: testCommentId, nestedCommentId: testNestedCommentId, willHeartComment: true)
    sink(fromPublisher: taskPublisher, withExpectation: expectation) { error, result in
      unexpectedError = error
      hasReceivedResult = result
    }.store(in: &subscriptions)
    wait(for: [expectation], timeout: 7.777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "updateNestedCommentHearts")
    XCTAssertTrue(hasReceivedResult, "대댓글 좋아요 호출시 필드가 증가해야하지만, 증가되지 않았습니다.")
  }
  
  func test_fetchNestedCommentHearts호출시해당필드가증가되는가() {
    // Arrange
    var hasReceivedResult: Bool = false
    var unexpectedError: Error?
    
    // Act
    let taskPublisher = sut.fetchNestedCommentHearts(with: testPostId, commentId: testCommentId, nestedCommentId: testNestedCommentId)
    sink(fromPublisher: taskPublisher, withExpectation: expectation) { error, result in
      unexpectedError = error
      hasReceivedResult = result
    }.store(in: &subscriptions)
    wait(for: [expectation], timeout: 7.777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchNestedCommentHearts")
    XCTAssertTrue(hasReceivedResult, "대댓글 필드에서 하트 개수 받아와야하지만 받아오지 않았습니다.")
  }
}
