//
//  PostNestedCommentHeartUseCaseImplTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/13/24.
//

import XCTest
import Combine
@testable import travelPlan
@testable import SHFirestoreService

final class PostNestedCommentHeartUseCaseImplTests: XCTestCase {
  var sut: PostNestedCommentHeartUseCaseImpl!
  var subscriptions = Set<AnyCancellable>()
  var expectation: XCTestExpectation!
  let testPostId = "ABEB803F-DD54-41A4-B8BF-487A210BD1EC"
  let testCommentId = "12181109-6CDE-46E5-AD4F-04E824E89581"
  let testNestedCommentId = "941C554D-CB1E-4B7E-A749-9DA76E67D960"
  
  override func setUp() {
    super.setUp()
    let service = FirestoreService()
    let postNestedCommentHeartRepository = FirestorePostNestedCommentHeartRepository(
      service: service,
      backgroundQueue: DispatchQueue(label: "background", qos: .background, attributes: .concurrent))
    let ownerRepository = DefaultLoggedInUserRepository(storage: MockUserStorage())
    sut = PostNestedCommentHeartUseCaseImpl(
      nestedCommentHeartRepository: postNestedCommentHeartRepository,
      ownerRepository: ownerRepository)
    expectation = XCTestExpectation(description: "PostNestedCommentHeartUseCaseImpl test!")
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    subscriptions.removeAll()
  }
}

extension PostNestedCommentHeartUseCaseImplTests {
  func test_toggleCommentHeart에서_댓글좋아요로직호출시_성공적으로isOnHeart받을수있는지() {
    // Arrange
    var unexpectedError: Error?
    var receivedResult: Bool = false
    
    // Act
    let testPublihser = sut.toggleNestedCommentHeart(
      postId: testPostId, commentId: testCommentId, nestedCommentId: testNestedCommentId)
      .map { _ in return () }
    sink(fromPublisher: testPublihser, withExpectation: expectation) { error, result in
      unexpectedError = error
      receivedResult = result
    }.store(in: &subscriptions)
    
    wait(for: [expectation], timeout: 7.777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "toggleNestedCommentHeart")
    XCTAssert(
      receivedResult,
      "toggleNestedCommentHeart 호출시 mockOwnerStorage의 id에 따라 heartNum 값 증가 또는 감소후 entity를 반환해야하는데 실패")
  }
}
