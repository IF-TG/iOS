//
//  XMLParsingServiceTests.swift
//  travelPlan
//
//  Created by 양승현 on 4/24/24.
//

import XCTest
import Combine
@testable import travelPlan

final class XMLParsingServiceTests: XCTestCase {
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

extension XMLParsingServiceTests {
  func test_XML목데이터로파싱할경우_예상하는값과일치반환해야함() {
    // Arrange
    let parser = XMLParser(data: mockXMLData)
    let expectedAttributes = [
      "errMsg": "SERVICE ERROR",
      "returnAuthMsg": "SERVICE_KEY_IS_NOT_REGISTERED_ERROR",
      "returnReasonCode": "30"]
    sut = XMLParsingService(parser: parser)
    expectation = expectation(description: "XMLParsingServiceTests end")
    var parsedAttributes: [String: String]?
    
    // Act
    subscription = sut.xmlParserNotifier
      .sink { [unowned self] _ in
        expectation.fulfill()
      } receiveValue: { [unowned self] attributes in
        print("DEBUG: 값을 성공적으로 받았습니다.\n\(attributes)\n\n")
        parsedAttributes = attributes
        expectation.fulfill()
      }
    
    sut.parse()
    wait(for: [expectation], timeout: 3)
    
    // Assert
    XCTAssertEqual(expectedAttributes, parsedAttributes) 
  }
  
  func test_JSON목데이터로파싱할경우_에러를던져야함() {
    // Arrange
    let parser = XMLParser(data: mockJSONData)
    sut = XMLParsingService(parser: parser)
    var occuredError: Error?
    expectation = expectation(description: "XMLParsingServiceTests end")
    
    // Act
    subscription = sut.xmlParserNotifier
      .sink { [unowned self] completion in
        if case .failure(let error) = completion {
          occuredError = error
          print("DEBUG: 잘못된 형식의 데이터에 대해서 에러가 성공적으로 반환됨.\n\(error)\n\n")
        }
        expectation.fulfill()
      } receiveValue: { [unowned self] _ in
        expectation.fulfill()
      }
    
    sut.parse()
    wait(for: [expectation], timeout: 3)
    
    // Assert
    XCTAssertNotNil(occuredError, "XMLParsingService에서 잘못된 json data 형식을 파싱할때 에러가 발생되어야하는데 에러가 발생되지 않음.")
  }
}
