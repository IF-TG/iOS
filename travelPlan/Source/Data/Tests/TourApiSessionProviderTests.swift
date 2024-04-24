//
//  TourApiSessionProvider.swift
//  travelPlanTests
//
//  Created by 양승현 on 4/24/24.
//

import XCTest
import Combine
@testable import travelPlan

final class TourApiSessionProviderTests: XCTestCase {
  // MARK: - Properties
  var sut: XMLParsingServiceProtocol!
  
  var subscription: AnyCancellable?
  
  let mockXMLData = """
  <OpenAPI_ServiceResponse>
    <cmmMsgHeader>
        <errMsg>SERVICE ERROR</errMsg>
        <returnAuthMsg>SERVICE_KEY_IS_NOT_REGISTERED_ERROR</returnAuthMsg>
        <returnReasonCode>30</returnReasonCode>
    </cmmMsgHeader>
  </OpenAPI_ServiceResponse>
  """.data(using: .utf8)!
  
  let mockJSONData = """
  {
    "errorMsg": "SERVICE ERROR"
  }
  """.data(using: .utf8)!
  
  var expectation: XCTestExpectation!
  
  // MARK: - Lifecycle
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    expectation = nil
    subscription = nil
  }
}
