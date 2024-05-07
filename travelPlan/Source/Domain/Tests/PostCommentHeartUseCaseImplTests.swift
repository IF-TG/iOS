//
//  PostCommentHeartUseCaseImplTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/6/24.
//

import XCTest
import Combine
@testable import travelPlan
@testable import SHFirestoreService

final class PostCommentHeartUseCaseImplTests: XCTestCase {
  var sut: PostCommentHeartUseCaseImpl!
  var subscriptions = Set<AnyCancellable>()
  let mockPostCommentRepository = MockPostCommentRepository()
  var expectation: XCTestExpectation!
  let testPostId = "ABEB803F-DD54-41A4-B8BF-487A210BD1EC"
  let testCommentId = "testComment1"

  override func setUp() {
    super.setUp()
    let service = FirestoreService()
    let postCommentHeartRepository = FirestorePostCommentHeartRepository(
      service: service,
      backgroundQueue: DispatchQueue(label: "background", qos: .background, attributes: .concurrent))
    let ownerRepository = DefaultLoggedInUserRepository(storage: MockUserStorage())
    sut = PostCommentHeartUseCaseImpl(
      commentHeartRepository: postCommentHeartRepository,
      ownerRepository: ownerRepository,
      backgroundQueue: DispatchQueue(label: "background", qos: .background, attributes: .concurrent))
    expectation = XCTestExpectation(description: "PostCommentHeartUseCaseImpl test!")
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    subscriptions.removeAll()
  }
}

extension PostCommentHeartUseCaseImplTests {
  func test_toggleCommentHeart에서_댓글좋아요로직호출시_성공적으로isOnHeart받을수있는지() {
    // Arrange
    var unexpectedError: Error?
    var receivedResult: Bool = false
    
    // Act
    sut.toggleCommentHeart(postId: testPostId, commentId: testCommentId)
      .receive(on: DispatchQueue.main)
      .sink { completion in
        if case .failure(let error) = completion {
          unexpectedError = error
          self.expectation.fulfill()
        }
      } receiveValue: { entity in
        receivedResult = true
        print("Received value: ", entity)
        self.expectation.fulfill()
      }.store(in: &self.subscriptions)
    
    wait(for: [expectation], timeout: 7.777)
      
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "toggleCommentHeart")
    XCTAssert(
      receivedResult,
      "toggleCommentHeart 호출시 mockOwnerStorage의 id에 따라 heartNum 값 증가 또는 감소후 entity를 반환해야하는데 실패")
  }
}
