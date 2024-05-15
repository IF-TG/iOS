//
//  FirestorePostHeartRepositoryTests.swift
//  travelPlan
//
//  Created by 양승현 on 5/1/24.
//

import Foundation

import XCTest
import Combine
import SHFirestoreService
import FirebaseFirestore
@testable import travelPlan

final class FirestorePostHeartRepositoryTests: XCTestCase {
  // MARK: - Properties
  var sut: PostHeartRepository!
  var expectation: XCTestExpectation!
  var subscriptions = Set<AnyCancellable>()
  let testPostId = "ABEB803F-DD54-41A4-B8BF-487A210BD1EC"
  let testUserId = "testUser1"
  
  override func setUp() {
    super.setUp()
    let service = FirestoreService()
    sut = FirestorePostHeartRepository(service: service)
    expectation = XCTestExpectation(description: "Finish")
  }
  
  override func tearDown() {
    super.tearDown()
    expectation = nil
    subscriptions.removeAll()
  }
}

extension FirestorePostHeartRepositoryTests {
  func test_heartPost호출시PostHearts컬랙션에사용자가등록되는지_ShouldReturnSuccess() {
    // Arrange
    var unexpectedError: Error?
    var receivedResult = false
    
    // Act
    sut.heartPost(testPostId, userId: testUserId)
      .sink { [unowned self] completion in
        if case .failure(let error) = completion {
          unexpectedError = error
          expectation.fulfill()
        }
      } receiveValue: { [unowned self] _ in
        receivedResult = true
        
        /// 저장한거 삭제..
        FirestoreRequestType
          .users(.heartPost(testUserId))
          .collectionRef
          .document(testPostId)
          .delete { _ in }
        
        expectation.fulfill()
      }.store(in: &subscriptions)

    wait(for: [expectation], timeout: 7.777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "heartPost")
    XCTAssertEqual(receivedResult, true, "heartPost를 호출할 경우 사용자 post-hearts에 post id가 등록되야하는데 등록되지 않음.")
  }
  
  /// 이전 테스트 코드를 불가피하게 활용해야 합니다.. 사전에 저장되어야 삭제가 가능한데 실제 firesotre 기반으로 테스트하기 때문입니다.
  func test_hatePost호출시PostHearts컬랙션에특정사용자가제거되는지_ShouldReturnSuccess() {
    // Arrange
    var unexpectedError: Error?
    var receivedResult = false
    
    sut.heartPost(testPostId, userId: testUserId)
      .sink {
        if case .failure = $0 { XCTAssert(false, "testPostId 문서 저장해야 하지만 에러가 발생됨.") }
      } receiveValue: { [unowned self] _ in
        expectation.fulfill()
      }.store(in: &subscriptions)

    wait(for: [expectation], timeout: 4)
    
    expectation = expectation(description: "사전준비 후 실제 테스트 시작..")
    // Act
    sut.hatePost(testPostId, userId: testUserId)
      .sink { [unowned self] completion in
        if case .failure(let error) = completion {
          unexpectedError = error
          expectation.fulfill()
        }
      } receiveValue: { [unowned self] _ in
        receivedResult = true
        expectation.fulfill()
      }.store(in: &subscriptions)
    
    wait(for: [expectation], timeout: 7.777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "hatePost")
    XCTAssertEqual(receivedResult, true, "heartPost를 호출할 경우 post id가 삭제되야 하지만 에러가 발생됨")

  }
  
  // MARK: - 이 함수를 테스트할 경우 db에서 테스트 문서 likeNum값을 0으로 지정해야 합니다,,
  func test_FetchPostHearts호출할경우_ShouldEqual() {
    // Arrange
    let expectedPostHearts = 0
    var receivedPostHearts = -1
    var unexpectedError: Error?
    
    // Act
    sut.fetchPostHearts(testPostId).sink {
      if case .failure(let error) = $0 {
        unexpectedError = error
        self.expectation.fulfill()
      }
    } receiveValue: { postHearts in
      print("received post hearts:", postHearts)
      receivedPostHearts = postHearts
      self.expectation.fulfill()
    }.store(in: &subscriptions)
    wait(for: [expectation], timeout: 7.777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchPosthearts")
    XCTAssertEqual(expectedPostHearts, receivedPostHearts, "fetchPostHearts를 호출할 경우 현재 디비에 저장된 heartNum을 받아와야 하지만 이상한 값을 받아옴.")
  }
  
  /// 포스트 좋아하는 유저 개수를 가져오기위해 sut.fetchPostHearts()가 사용됩니다.
  func test_updatePostHearts에서포스트좋아할경우_ShouldReturnTrue() {
    // Arrange
    var unexpectedError: Error?
    var expectedPostHearts: Int?
    var receivedPostHearts: Int?
    
    let firstExpectation = expectation(description: "사전 준비 함수 호출")
    sut.fetchPostHearts(testPostId).sink {
      if case .failure = $0 { XCTAssert(
        false,
        "updatePostHearts가 아닌, 사전 준비 함수에서 에러 발생. testPostId 문서의 postHearts가져와야하지만 에러가 발생됨.") }
    } receiveValue: { postHearts in
      expectedPostHearts = postHearts + 1
      firstExpectation.fulfill()
    }.store(in: &subscriptions)
    wait(for: [firstExpectation], timeout: 4)
    
    // Act
    sut.updatePostHearts(testPostId, willHeartPost: true)
      .sink { [unowned self] completion in
        if case .failure(let error) = completion {
          unexpectedError = error
          expectation.fulfill()
        }
      } receiveValue: { [unowned self] _ in
        sut.fetchPostHearts(testPostId).sink {
          if case .failure = $0 { XCTAssert(
            false,
            "updatePostHearts가 아닌 다른 비동기 함수에서 에러 발생. testPostId 문서의 postHearts가져와야하지만 에러가 발생됨.") }
        } receiveValue: { [unowned self] postHearts in
          receivedPostHearts = postHearts
          expectation.fulfill()
        }.store(in: &subscriptions)
      }.store(in: &subscriptions)
    
    wait(for: [expectation], timeout: 7.777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "updatePostHearts")
    XCTAssertEqual(expectedPostHearts, receivedPostHearts, "togglePostHearts에서 willPostHeart == true 호출할 경우 이전에 저장된 포스트 하트 개수에 +1이 반영되야하지만 이상한 값이 반영됨.")
  }
  
  /// 포스트 좋아하는 유저 개수를 가져오기위해 sut.fetchPostHearts()가 사용됩니다.
  func test_updatePostHearts에서포스트싫어할경우_ShouldReturnTrue() {
    // Arrange
    var unexpectedError: Error?
    var expectedPostHearts: Int?
    var receivedPostHearts: Int?
    
    let firstExpectation = expectation(description: "사전 준비 함수 호출")
    sut.fetchPostHearts(testPostId).sink {
      if case .failure = $0 { XCTAssert(
        false,
        "updatePostHearts가 아닌, 사전 준비 함수에서 에러 발생. testPostId 문서의 postHearts가져와야하지만 에러가 발생됨.") }
    } receiveValue: { postHearts in
      expectedPostHearts = postHearts - 1
      firstExpectation.fulfill()
    }.store(in: &subscriptions)
    wait(for: [firstExpectation], timeout: 4)
    
    // Act
    sut.updatePostHearts(testPostId, willHeartPost: false)
      .sink { [unowned self] completion in
        if case .failure(let error) = completion {
          unexpectedError = error
          expectation.fulfill()
        }
      } receiveValue: { [unowned self] _ in
        sut.fetchPostHearts(testPostId).sink {
          if case .failure = $0 { XCTAssert(
            false,
            "updatePostHearts가 아닌 다른 비동기 함수에서 에러 발생. testPostId 문서의 postHearts가져와야하지만 에러가 발생됨.") }
        } receiveValue: { [unowned self] postHearts in
          receivedPostHearts = postHearts
          expectation.fulfill()
        }.store(in: &subscriptions)
      }.store(in: &subscriptions)
    
    wait(for: [expectation], timeout: 7.777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "updatePostHearts")
    XCTAssertEqual(expectedPostHearts, receivedPostHearts, "updatePostHearts에서 willPostHeart == true 호출할 경우 이전에 저장된 포스트 하트 개수에 -1이 반영되야하지만 이상한 값이 반영됨.")
  }
}
