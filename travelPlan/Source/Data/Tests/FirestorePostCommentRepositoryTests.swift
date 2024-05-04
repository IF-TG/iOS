//
//  FirestorePostCommentRepositoryTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/4/24.
//

import XCTest
import Combine
@testable import SHFirestoreService
@testable import travelPlan

final class FirestorePostCommentRepositoryTests: XCTestCase {
  // MARK: - Properties
  var sut: PostCommentRepository!
  var expectation: XCTestExpectation!
  var subscriptions = Set<AnyCancellable>()
  let testPostId = "ABEB803F-DD54-41A4-B8BF-487A210BD1EC"
  
  override func setUp() {
    super.setUp()
    let service = FirestoreService()
    
    let loggedInUserRepository = DefaultLoggedInUserRepository(storage: MockUserStorage())
    sut = FirestorePostCommentRepository(
      service: service,
      backgroundQueue: .main,
      firebaseStorageService: MockFirestoreImageStorage(),
      loggedInUserRepository: loggedInUserRepository,
      myProfileRepository: MockMyProfileRepository(),
      imageCache: ImageMemoryCache())
    expectation = XCTestExpectation(description: "Finish")
  }
  
  override func tearDown() {
    super.tearDown()
    expectation = nil
    subscriptions.removeAll()
  }
}

extension FirestorePostCommentRepositoryTests {
  func test_sendComment호출시관련Entity를받는지_shouldReturnTrue() {
    // Arrange
    var receivedResult = false
    var unexpectedError: Error?
     
    // Act
    sut.sendComment(postId: testPostId, comment: "댓글 작성!")
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
}
