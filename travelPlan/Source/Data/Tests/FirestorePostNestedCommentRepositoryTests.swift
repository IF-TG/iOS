//
//  FirestorePostNestedCommentRepositoryTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/7/24.
//

import XCTest
import Combine
@testable import FirebaseFirestore
@testable import SHFirestoreService
@testable import travelPlan

final class FirestorePostNestedCommentRepositoryTests: XCTestCase {
  // MARK: - Properties
  var sut: PostAtomicNestedCommentRepository!
  var expectation: XCTestExpectation!
  var subscriptions = Set<AnyCancellable>()
  let testPostId = "ABEB803F-DD54-41A4-B8BF-487A210BD1EC"
  let testCommentId = "12181109-6CDE-46E5-AD4F-04E824E89581"
  let testNestedCommentId = "D219E2C2-4171-4C9D-B77D-EDB0CEFCD5B1"
  var mockUserId: String {
    StubOwnerStorage().id ?? "짱구1234"
  }
  
  override func setUp() {
    super.setUp()
    let service = FirestoreService()
    sut = FirestorePostNestedCommentRepository(service: service)
    expectation = XCTestExpectation(description: "대댓글 관련 테스트 !!")
  }
  
  override func tearDown() {
    super.tearDown()
    expectation = nil
    subscriptions.removeAll()
  }
}

extension FirestorePostNestedCommentRepositoryTests {
  func test_sendNestedComment호출시관련Entity를받는가_ShouldReturnTrue() {
    // Arrange
    var receivedResult = false
    var unexpectedError: Error?
    
    // Act
    sut.sendNestedComment(ownerId: mockUserId, postId: testPostId, commentId: testCommentId, comment: "대댓글입력!")
      .receive(on: DispatchQueue.main)
      .sink { completion in
        if case .failure(let error) = completion {
          unexpectedError = error
          self.expectation.fulfill()
        }
      } receiveValue: { entity in
        print("DEBUG: 값을 성공적으로 받았습니다. \(entity)")
        receivedResult.toggle()
        self.expectation.fulfill()
      }.store(in: &subscriptions)
    wait(for: [expectation], timeout: 7.777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "sendNestedComment")
    XCTAssertTrue(receivedResult)
  }
  
  /// 통합테스트..? 사전작업으로 위에서 테스트한 함수를 활용해야합니다.
  func test_deleteNestedComment호출시성공적으로값을방출하는지() {
    // Arrange
    var receivedResult = false
    var unexpectedError: Error?
    
    var nestedCommentId: String = ""
    let prepareForTestExpectation = expectation(description: "사전작업")
    sut.sendNestedComment(ownerId: mockUserId, postId: testPostId, commentId: testCommentId, comment: "테스트")
      .receive(on: DispatchQueue.main)
      .sink {
        if case .failure = $0 {
          XCTAssert(false,"DeleteNestedCommet 사전 작업으로 sendNestedComment호출시 에러발생. 이 경우 다시 테스트해야합니다.")
          prepareForTestExpectation.fulfill()
        }
      } receiveValue: { entity in
        nestedCommentId = entity.nestedCommentId
        prepareForTestExpectation.fulfill()
      }.store(in: &subscriptions)
    wait(for: [prepareForTestExpectation], timeout: 7.777)
    
    // Act
    sut.deleteNestedComment(postId: testPostId, commentId: testCommentId, nestedCommentId: nestedCommentId)
      .receive(on: DispatchQueue.main)
      .sink { completion in
        if case .failure(let error) = completion {
          unexpectedError = error
          self.expectation.fulfill()
        }
      } receiveValue: { entity in
        print("DEBUG: 값을 성공적으로 받았습니다. \(entity)")
        receivedResult.toggle()
        self.expectation.fulfill()
      }.store(in: &subscriptions)
    wait(for: [expectation], timeout: 7.777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "deleteNestedComment")
    XCTAssertTrue(receivedResult)
  }
  
  func test_updateNestedComment호출시관련Entity를받는가_ShouldReturnTrue() {
    // Arrange
    var receivedResult = false
    var unexpectedError: Error?
    
    // Act
    sut.updateNestedComment(
      postId: testPostId, commentId: testCommentId, nestedCommentId: testNestedCommentId,
      comment: "대댓글수정!\(DateTimeConverter.toString(from: Date()))")
    .receive(on: DispatchQueue.main)
    .sink { completion in
      if case .failure(let error) = completion {
        unexpectedError = error
        self.expectation.fulfill()
      }
    } receiveValue: { entity in
      print("DEBUG: 값을 성공적으로 받았습니다. \(entity)")
      receivedResult.toggle()
      self.expectation.fulfill()
    }.store(in: &subscriptions)
    wait(for: [expectation], timeout: 7.777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "updateNestedComment")
    XCTAssertTrue(receivedResult)
  }
  
  func test_fetchNestedComments호출시관련Entity를받는가_ShouldReturnTrue() {
    // Arrange
    var receivedResult = false
    var unexpectedError: Error?
    
    // Act
    sut.fetchNestedComments(postId: testPostId, commentId: testCommentId)
    .receive(on: DispatchQueue.main)
    .sink { completion in
      if case .failure(let error) = completion {
        unexpectedError = error
        self.expectation.fulfill()
      }
    } receiveValue: { entity in
      print("DEBUG: 값을 성공적으로 받았습니다. \(entity)")
      receivedResult.toggle()
      self.expectation.fulfill()
    }.store(in: &subscriptions)
    wait(for: [expectation], timeout: 7.777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "updateNestedComment")
    XCTAssertTrue(receivedResult)
  }
  
  func test_fetchTheNumberOfnestedComments호출시대댓글전체개수를받는지_ShouldReturnTrue() {
    // Arrange
    var receivedResult = false
    var unexpectedError: Error?
    
    // Act
    sut.fetchTheNumberOfNestedComments(postId: testPostId, commentId: testCommentId)
      .receive(on: DispatchQueue.main)
      .sink { completion in
        if case .failure(let error) = completion {
          unexpectedError = error
          self.expectation.fulfill()
        }
      } receiveValue: { result in
        print("DEBUG: 값을 성공적으로 받았습니다. \(result)")
        receivedResult.toggle()
        self.expectation.fulfill()
      }.store(in: &subscriptions)
    wait(for: [expectation], timeout: 7.777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "updateNestedComment")
    XCTAssertTrue(receivedResult, "값을 받아야하지만 값을 받지 못했습니다.")
  }
  
  /// 이전에 테스트한 sendNestedComment(ownerId:postId:commentId:)가 사용됩니다.
  func test_deleteAllNestedComments호출시성공작으로삭제작업이진행되는지_ShouldReturnTrue() {
    // Arrange
    var receivedResult = false
    var unexpectedError: Error?
    
    // 사전 준비..
    let prepareExpectation = expectation(description: "사전 준비 작업 시작")
    let seq = (0...1).map {
      sut.sendNestedComment(ownerId: "test1", postId: testPostId, commentId: "testComment3", comment: "test\($0)")
    }
    Publishers.Zip(seq[0], seq[1])
      .sink {
        if case .failure = $0 {
          XCTAssert(false, "사전 준비작업으로 대댓글 두개 저장로직에서 에러 발생됬습니다.")
        }
      } receiveValue: { _ in
        prepareExpectation.fulfill()
      }.store(in: &subscriptions)
    wait(for: [prepareExpectation], timeout: 7.777)

    // Act
    sut.deleteAllNestedComments(postId: testPostId, commentId: "testComment3")
      .receive(on: DispatchQueue.main)
      .sink { completion in
        if case .failure(let error) = completion {
          unexpectedError = error
          self.expectation.fulfill()
        }
      } receiveValue: { entity in
        print("DEBUG: 값을 성공적으로 받았습니다. \(entity)")
        receivedResult.toggle()
        self.expectation.fulfill()
      }.store(in: &subscriptions)
    wait(for: [expectation], timeout: 7.777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "deleteAllNestedComments")
    XCTAssertTrue(receivedResult)
  }
}
