//
//  PostFetchUseCaseImplTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/16/24.
//

import XCTest
import Combine
@testable import travelPlan

final class PostFetchUseCaseImplTests: XCTestCase {
  var sut: PostFetchUseCase!
  var subscription: AnyCancellable?
  var expectation: XCTestExpectation!
  
  // MARK: - Lifecycle
  override func setUp() {
    super.setUp()

    sut = PostFetchUseCaseImpl(
      postFetchAtomicRepository: MockPostFetchAtomicRepository(),
      userProfileRepository: MockUserProfileRepository(),
      postHeartRepository: MockPostHeartRepository(),
      ownerHeartPostRepository: MockOwnerHeartPostRepository())
    expectation = XCTestExpectation(description: "Finish")
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    subscription = nil
    expectation = nil
  }
}
