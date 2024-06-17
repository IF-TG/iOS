//
//  FirestorePostAtomicCommentRepositoryTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/4/24.
//

import XCTest
import Combine
@testable import FirebaseFirestore
@testable import SHFirestoreService
@testable import travelPlan

final class FirestorePostAtomicCommentRepositoryTests: XCTestCase {
  // MARK: - Properties
  var sut: PostAtomicCommentRepository!
  var expectation: XCTestExpectation!
  var subscriptions = Set<AnyCancellable>()
  // MARK: - Identifier
  // firestore의 identifer들은 String 입니다 하지만 spring server에서는 Int로 Identifier를 제공하고, 현재
  // spring server를 사용하기에 Int64숫자 임의대로 지정했습니다. 테스트는 결과는 전부 false됩니다...
  // target은 추가히지 않았습니다.
  // let testPostId = "ABEB803F-DD54-41A4-B8BF-487A210BD1EC"
  // let testCommentId = "12181109-6CDE-46E5-AD4F-04E824E89581"
  let testPostId: PostIdentifier = 1
  let testCommentId: CommentIdentifier = 1
  
  override func setUp() {
    super.setUp()
    let service = FirestoreService()
    sut = FirestorePostCommentRepository(
      service: service,
      backgroundQueue: .main)
    expectation = XCTestExpectation(description: "Finish")
  }
  
  override func tearDown() {
    super.tearDown()
    expectation = nil
    subscriptions.removeAll()
  }
}

extension FirestorePostAtomicCommentRepositoryTests {
  func test_sendComment호출시관련Entity를받는지_shouldReturnTrue() {
    // Arrange
    var receivedResult = false
    var unexpectedError: Error?
     
    // Act
    sut.sendComment(ownerId: 1, postId: testPostId, comment: "댓글 작성!")
      .sink {
        if case .failure(let error) = $0 {
          unexpectedError = error
          self.expectation.fulfill()
        }
      } receiveValue: { commentEntity in
        print("DEBUG: 값을 성공적으로 받았습니다\n \(commentEntity)")
        receivedResult = true
        self.expectation.fulfill()
      }.store(in: &subscriptions)
    
    wait(for: [expectation], timeout: 7.777)

    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "sendComment")
    XCTAssertTrue(receivedResult, "sendComment호출시 값을 성공적으로 받아야하지만 받지 못했습니다.")
  }
  
  func test_updateComment호출시성공적으로결과를받는지() {
    // Arrange
    var receivedResult = false
    var unexpectedError: Error?
    
    // Act
    sut.updateComment(postId: testPostId, commentId: testCommentId, comment: "댓글 수정!")
      .sink {
        if case .failure(let error) = $0 {
          unexpectedError = error
          self.expectation.fulfill()
        }
      } receiveValue: { _ in
        receivedResult = true
        self.expectation.fulfill()
      }.store(in: &subscriptions)
    
    wait(for: [expectation], timeout: 7.777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "sendComment")
    XCTAssertTrue(receivedResult, "sendComment호출시 값을 성공적으로 받아야하지만 받지 못했습니다.")
  }
  
  func test_대댓글이없는경우deleteComment호출시성공적으로삭제되는지() {
    // Arrange
    var receivedResult = false
    var unexpectedError: Error?
    let testCommentId = 1
    // Act
    sut.deleteComment(
      hasAnyNestedCommentExisted: false,
      postId: testPostId,
      commentId: 1
    ).sink { completion in
      if case .failure(let error) = completion {
        unexpectedError = error
        self.expectation.fulfill()
      }
    } receiveValue: { _ in
      receivedResult = true
      Firestore.firestore()
        .collection("posts/\(self.testPostId)/comments")
        .document(String(testCommentId))
        .setData(["temp": "temp"])
        .sink { completion in
          if case .failure(let error) = completion {
            XCTAssert(false, "파이어스토어에 삭제한 문서를 원래대로 되돌려 놓는 과정에서 에러 발생:\(error)")
          }
        } receiveValue: { _ in
          self.expectation.fulfill()
        }.store(in: &self.subscriptions)
    }.store(in: &self.subscriptions)
    
    wait(for: [expectation], timeout: 7.777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "deleteComment")
    XCTAssertTrue(receivedResult, "댓글 삭제시 성공적으로 true를 반환해야하지만 반환하지 않음.")
  }
  
  func test_대댓글이있는경우deleteComment호출시성공적으로hasDeleted필드가반영되는지() {
    // Arrange
    var receivedResult = false
    var unexpectedError: Error?
    let testCommentId = 2
    // Act
    sut.deleteComment(
      hasAnyNestedCommentExisted: true,
      postId: testPostId,
      commentId: 2
    ).sink { completion in
      if case .failure(let error) = completion {
        unexpectedError = error
        self.expectation.fulfill()
      }
    } receiveValue: { _ in
      receivedResult = true
      Firestore.firestore()
        .collection("posts/\(self.testPostId)/comments")
        .document(String(testCommentId))
        .setData(["hasDeleted": "false"])
        .sink { completion in
          if case .failure(let error) = completion {
            XCTAssert(false, "파이어스토어에 삭제한 문서를 원래대로 되돌려 놓는 과정에서 에러 발생:\(error)")
          }
        } receiveValue: { _ in
          self.expectation.fulfill()
        }.store(in: &self.subscriptions)
    }.store(in: &self.subscriptions)
    
    wait(for: [expectation], timeout: 7.777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "deleteComment")
    XCTAssertTrue(receivedResult, "댓글 삭제시 성공적으로 true를 반환해야하지만 반환하지 않음.")
  }

}
