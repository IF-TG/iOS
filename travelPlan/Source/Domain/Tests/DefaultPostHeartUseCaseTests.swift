//
//  DefaultPostHeartUseCaseTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/3/24.
//

import XCTest
import Combine
@testable import FirebaseFirestore
@testable import SHFirestoreService
@testable import travelPlan

final class DefaultPostHeartUseCaseTests: XCTestCase {
  // MARK: - Properties
  var sut: PostHeartUseCase!
  var subscriptions = Set<AnyCancellable>()
  var expectation: XCTestExpectation!
  let testPostId = "ABEB803F-DD54-41A4-B8BF-487A210BD1EC"
  
  // MARK: - Lifecycle
  override func setUp() {
    super.setUp()
    let backgroundQueue = DispatchQueue.global(qos: .userInteractive)
    let service = FirestoreService()
    let postHeartRepository = FirestorePostHeartRepository(service: service, backgroundQueue: backgroundQueue)
    let mockStorage = MockUserStorage()
    let loggedInUserRepository = DefaultLoggedInUserRepository(storage: mockStorage)
    sut = DefaultPostHeartUseCase(
      backgroundQueue: backgroundQueue,
      postHeartRepository: postHeartRepository,
      loggedInUserRepository: loggedInUserRepository)
    expectation = XCTestExpectation(description: "PostHeartUseCase 테스트. Firestore에 실제 접근합니다.")
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    subscriptions.removeAll()
    expectation = nil
  }
}

// MARK: 이 테스트는 실제 파이어스토어에 테스트 문서에서 진행되는 테스트입니다.
extension DefaultPostHeartUseCaseTests {
  func test_postHeart를눌렀을때성공적으로Void를반환하는지테스트() {
    // Arrange
    var hasReceivedResult = false
    var unexpectedErr: Error?
    
    // Act
    sut.heartPost(testPostId)
      .receive(on: DispatchQueue.main)
      .sink {
        if case .failure(let error) = $0 {
          unexpectedErr = error
          self.expectation.fulfill()
        }
      } receiveValue: { _ in
        hasReceivedResult = true
        self.expectation.fulfill()
      }.store(in: &subscriptions)
    
    wait(for: [expectation], timeout: 7.777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedErr, functionName: "postHeartUseCase.heartPost")
    XCTAssertTrue(hasReceivedResult, "포스트 좋아요 누를때 Void를 반환받아야 하지만 받지 못했습니다.")
  }
  
  // 이상하게.. FieldValue.increment() +1은 처음엔 잘되고 두번째 연이어 호출하면 +2씩 증가가됩니다.
  // increment()에서 -1을 해도 처음엔 db에 감소되지 않고 두번이상할떄 차감됩니다
  // 그래서 그냥 트랜젝션에 로직을 추가했습니다.
  func test_hateHeart를눌렀을때성공적으로Void를반환하는지테스트() {
    // Arrange
    var hasReceivedResult = false
    var unexpectedErr: Error?
    
    // Act
    sut.hatePost(testPostId)
      .receive(on: DispatchQueue.main)
      .sink {
        if case .failure(let error) = $0 {
          unexpectedErr = error
          self.expectation.fulfill()
        }
      } receiveValue: { _ in
        hasReceivedResult = true
        self.expectation.fulfill()
      }.store(in: &subscriptions)
    
    wait(for: [expectation], timeout: 7.777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedErr, functionName: "postHeartUseCase.heartPost")
    XCTAssertTrue(hasReceivedResult, "포스트 좋아요 누를때 Void를 반환받아야 하지만 받지 못했습니다.")
  }
}
