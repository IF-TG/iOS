//
//  PostRepositoryTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 3/23/24.
//

import XCTest
import Combine
@testable import travelPlan

final class PostRepositoryTests: XCTestCase {
  // MARK: - Properties
  typealias sut = PostRepository
  let mockSession = MockSession.default
  var expectation: XCTestExpectation!
  var subscriptions: Set<AnyCancellable> = .init()
  
  override func setUp() {
    super.setUp()
    subscriptions = .init()
  }
  
  override func tearDown() {
    super.tearDown()
    expectation = nil
    subscriptions.removeAll()
  }
}

// MARK: - Test
extension PostRepositoryTests {
  func testPostRepository_정확한Endpoint가만들어졌는지_ShouldReturnTrue() {
    // Arrange
    
    // Act
    
    
    // Assert

  }
}
