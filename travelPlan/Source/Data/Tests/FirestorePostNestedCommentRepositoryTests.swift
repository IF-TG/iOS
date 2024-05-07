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
  var mockUserId: String {
    MockUserStorage().id ?? "짱구1234"
  }
  
  override func setUp() {
    super.setUp()
    let service = FirestoreService()
    sut = FirestorePostNestedCommentRepository(service: service)
    expectation = XCTestExpectation(description: "Finish")
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
}
