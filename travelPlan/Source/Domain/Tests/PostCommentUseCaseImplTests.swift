//
//  PostCommentUseCaseImplTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/14/24.
//

import XCTest
import Combine
@testable import travelPlan
@testable import SHFirestoreService

final class PostCommentUseCaseImplTests: XCTestCase {
  var sut: PostCommentUseCaseImpl!
  var subscriptions = Set<AnyCancellable>()
  var expectation: XCTestExpectation!
  
  let stubPostAtomicCommentRepository = StubPostAtomicCommentRepository()
  let stubPostAtomicNestedCommentRepository = StubPostAtomicNestedCommentRepository()
  let mockUserProfileRepository = MockUserProfileRepository()
  let stubPostNestedCommentHeartRepository = StubPostNestedCommentHeartRepository()
  let stubPostCommentHeartRepository = StubPostCommentHeartRepository()
  
  override func setUp() {
    super.setUp()
    let service = FirestoreService()
    let postNestedCommentHeartRepository = FirestorePostNestedCommentHeartRepository(
      service: service,
      backgroundQueue: DispatchQueue(label: "background", qos: .background, attributes: .concurrent))
    let ownerRepository = DefaultLoggedInUserRepository(storage: MockUserStorage())
    sut = PostCommentUseCaseImpl(
      ownerRepository: DefaultLoggedInUserRepository(storage: MockUserStorage()),
      postAtomicCommentRepository: stubPostAtomicCommentRepository,
      postNestedCommentRepository: stubPostAtomicNestedCommentRepository,
      userProfileRepository: mockUserProfileRepository,
      postNestedCommentHeartRepository: stubPostNestedCommentHeartRepository,
      postCommentHeartRepository: stubPostCommentHeartRepository,
      backgroundQueue: DispatchQueue.global(qos: .background))
    expectation = XCTestExpectation(description: "PostNestedCommentHeartUseCaseImpl test!")
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    subscriptions.removeAll()
  }
}

extension PostCommentUseCaseImplTests {
  func test_fetchComments호출시_정상적으로_comments가받아지는가() {
    // Arrange
    var unexpectedError: Error?
    var receivedResult: Bool = false
    
    // Act
    let publisher = sut.fetchComments(with: .init(page: 0, perPage: 0, postId: "1"))
      .map { print($0); return () }
    
    sink(fromPublisher: publisher, withExpectation: expectation) { error, result in
      unexpectedError = error
      receivedResult = result
    }.store(in: &subscriptions)
    wait(for: [expectation], timeout: 7.777)

    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchComments")
    XCTAssert(
      receivedResult,
      "fetchComments 호출시 postId에 따른 댓글, 대댓글 리스트를 받아와야하지만 받지 못했습니다.")
  }
}
