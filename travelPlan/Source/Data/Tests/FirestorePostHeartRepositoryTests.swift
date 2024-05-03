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
  func test_PostHearts컬랙션이없을때FetchHeartUsers호출시_빈문자열을반환해야함() {
    // Arrange
    var unexpectedError: Error?
    var usersID: [String] = []
    
    // Act
    sut.fetchHeartUsers(testPostId)
      .sink { [unowned self] completion in
        if case .failure(let error) = completion {
          unexpectedError = error
        }
        expectation.fulfill()
      } receiveValue: { [unowned self] result in
        usersID = result
        expectation.fulfill()
      }.store(in: &subscriptions)

    wait(for: [expectation], timeout: 10)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchHeartUsers")
    XCTAssertEqual(usersID.count, 0, "테스트 포스트ID의 user-hearts컬랙션이 없을때 빈 문자열을 반환해야하지만 예상치 못한 값을 받게됨.")
  }
  
  func test_heartPost호출시PostHearts컬랙션에사용자가등록되는지_ShouldReturnSuccess() {
    // Arrange
    let testUserId = "TestUser1234"
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
          .posts(.heartPost(testPostId))
          .collectionRef
          .document(testUserId)
          .delete { _ in }
        
        expectation.fulfill()
      }.store(in: &subscriptions)

    wait(for: [expectation], timeout: 7.777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "heartPost")
    XCTAssertEqual(receivedResult, true, "heartPost를 호출할 경우 post를 좋아하는 사용자가 등록되야하는데 해당 문서가 저장되지 않음.")
  }
  
  /// 이전 테스트 코드를 불가피하게 활용해야 합니다.. 사전에 저장되어야 삭제가 가능한데 실제 firesotre 기반으로 테스트하기 때문입니다.
  func test_hatePost호출시PostHearts컬랙션에특정사용자가제거되는지_ShouldReturnSuccess() {
    // Arrange
    let testUserId = "TestUser1234"
    var unexpectedError: Error?
    var receivedResult = false
    
    sut.heartPost(testPostId, userId: testUserId)
      .sink {
        if case .failure = $0 { XCTAssert(false, "testUserId 문서 저장해야 하지만 에러가 발생됨.") }
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
    XCTAssertEqual(receivedResult, true, "heartPost를 호출할 경우 post를 싫어하는 사용자가 삭제되야 하지만 에러가 발생됨")

  }
  
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
    XCTAssertEqual(expectedPostHearts, receivedPostHearts, "fetchPostHearts를 호출할 경우 현재 디비에 저장된 likeNum을 받아와야 하지만 이상한 값을 받아옴.")
  }
  
  /// 포스트 좋아하는 유저 개수를 가져오기위해 sut.fetchPostHearts()가 사용됩니다.
  func test_togglePostHearts에서포스트좋아할경우_ShouldReturnTrue() {
    // Arrange
    let testUserId = "TestUser1234"
    var unexpectedError: Error?
    var expectedPostHearts: Int?
    var receivedPostHearts: Int?
    
    let firstExpectation = expectation(description: "사전 준비 함수 호출")
    sut.fetchPostHearts(testPostId).sink {
      if case .failure = $0 { XCTAssert(
        false,
        "togglePostHearts가 아닌, 사전 준비 함수에서 에러 발생.testUserId 문서의 postHearts가져와야하지만 에러가 발생됨.") }
    } receiveValue: { postHearts in
      expectedPostHearts = postHearts + 1
      firstExpectation.fulfill()
    }.store(in: &subscriptions)
    wait(for: [firstExpectation], timeout: 4)
    
    // Act
    sut.togglePostHearts(testPostId, willHeartPost: true)
      .sink { [unowned self] completion in
        if case .failure(let error) = completion {
          unexpectedError = error
          expectation.fulfill()
        }
      } receiveValue: { [unowned self] _ in
        sut.fetchPostHearts(testPostId).sink {
          if case .failure = $0 { XCTAssert(
            false,
            "togglePostHearts가 아닌 다른 비동기 함수에서 에러 발생.testUserId 문서의 postHearts가져와야하지만 에러가 발생됨.") }
        } receiveValue: { [unowned self] postHearts in
          receivedPostHearts = postHearts
          expectation.fulfill()
        }.store(in: &subscriptions)
      }.store(in: &subscriptions)
    
    wait(for: [expectation], timeout: 7.777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "hatePost")
    XCTAssertEqual(expectedPostHearts, receivedPostHearts, "togglePostHearts에서 willPostHeart == true 호출할 경우 이전에 저장된 포스트 하트 개수에 +1이 반영되야하지만 이상한 값이 반영됨.")
  }
}
