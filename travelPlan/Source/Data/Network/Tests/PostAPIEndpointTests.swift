//
//  PostAPIEndpoint.swift
//  travelPlanTests
//
//  Created by 양승현 on 3/7/24.
//

import XCTest

final class PostAPIEndpoint: XCTestCase {
  typealias sut = PostAPIEndpoint
  let mockSession = MockSession.default
  var expectation: XCTestExpectation!

  override func setUp() {
    super.setUp()
    MockUrlProtocol.requestHandler = { _ in return ((HTTPURLResponse(), Data())) }
  }
  
  override func tearDown() {
    super.tearDown()
    expectation = nil
  }
  
  // MARK: - Tests
  func testPostAPIEndpoint_fetch
}
