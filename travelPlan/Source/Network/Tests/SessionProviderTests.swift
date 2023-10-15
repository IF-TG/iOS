//
//  SessionProviderTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 10/16/23.
//

import Combine
import Alamofire
import XCTest
@testable import travelPlan

final class SessionProviderTests: XCTestCase {
  var sut: Endpoint<UserNameResponseModel>!
  var mockRequestModel = UserNameRequestModel(name: "iosDeveloper:]", id: 1334)
  let mockSession: Session!
  var expectation: XCTestExpectation!

  override func setUp() {
    super.setUp()
    sut = Endpoint(
      scheme: "https",
      host: "test.com",
      method: .get,
      prefixPath: "/user",
      parameters: mockRequestModel,
      requestType: .custom("name-update"))
    MockUrlProtocol.requestHandler = { _ in
      return ((HTTPURLResponse(), Data()))
    }
    expectation = expectation(description: "finish")
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    expectation = nil
  }

}
