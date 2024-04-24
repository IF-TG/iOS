//
//  TourApiSessionProviderTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 4/24/24.
//

import XCTest
import Combine
@testable import travelPlan

final class TourApiSessionProviderTests: XCTestCase {
  // MARK: - Properties
  var sut: TourApiSessionProvider!
  
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
    "responseTime": "2024-04-24",
    "resultMsg": "SERVICE ERROR",
    "resultCode": "03"
  }
  """.data(using: .utf8)!
  
  
  var expectation: XCTestExpectation!
  
  // MARK: - Lifecycle
  override func setUp() {
    super.setUp()
    sut = TourApiSessionProvider(session: MockSession.default)
    expectation = expectation(description: "finish")
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    expectation = nil
    subscription = nil
  }
}

// MARK: - TODO.
// TourApiSessionProvider를 사용할때 예상치 못한 xml, error만 담긴 json data등 데이터를 받은 경우 상황에 따라 지정된 Error를
//    던지는지 테스트
extension TourApiSessionProviderTests {
  func test_reqeust함수가서버에서MockXMLData받은경우_예상된공공데이터포털에러를반환해야함() {
    // Arrange
    MockUrlProtocol.requestHandler = { [unowned self] _ in return (.init(), mockXMLData) }
    
    // Act
    let mockEndpoint = mockEndpointProvider.make()
    var responseError: Error?
    
    subscription = sut.request(endpoint: mockEndpoint)
      .sink { [unowned self] completion in
        if case .failure(let error) = completion {
          print("\nAn expected error occured: \(error)\n\n")
          responseError = error
        }
        self.expectation.fulfill()
      } receiveValue: { responseDTO in
        XCTFail("에러를 받아야하는데 responsDTO를 받게됨.")
      }
    
    wait(for: [expectation], timeout: 3)
    
    // Assert
    XCTAssertNotNil(responseError, "An error must be thrown when parsing XML data, but it should not occur for other types of data parsing.")
    switch responseError!.asAFError {
    case .responseSerializationFailed(reason: .decodingFailed(error: let error)):
      if let tourAPIError = error as? TourAPIError {
        switch tourAPIError {
        case .publicDataPortalError(let publicDataPortalInTourAPIError):
          XCTAssertEqual(
            publicDataPortalInTourAPIError,
            .serviceKeyIsNotRegisteredError,
            "Error should return serviceKeyIsNotRegisteredError, but it throwed another case error: \(publicDataPortalInTourAPIError.localizedDescription)")
        default:
          XCTFail("Error should return of type TourAPIError's publicDataPortalError case, but it thorwed another case error:\(error.localizedDescription)")
        }
      } else {
        XCTFail("Error should return of type TourAPIError, but it thorwed unexpected error:\(error.localizedDescription)")
      }
    default:
      XCTFail("Error should return of type ResponseSerializationFailedReason, but it thorwed unexpected error: \(responseError!.localizedDescription)")
    }
  }
  
  func test_reqeust함수가서버에서Error만담긴JsonData받은경우_예상된제공기관에러를반환해야함() {
    // Arrange
    MockUrlProtocol.requestHandler = { [unowned self] _ in return (.init(), mockJSONData) }
    
    // Act
    let mockEndpoint = mockEndpointProvider.make()
    var responseError: Error?
    
    subscription = sut.request(endpoint: mockEndpoint)
      .sink { [unowned self] completion in
        if case .failure(let error) = completion {
          print("\nAn expected error occured: \(error)\n\n")
          responseError = error
        }
        self.expectation.fulfill()
      } receiveValue: { responseDTO in
        XCTFail("에러를 받아야하는데 responsDTO를 받게됨.")
      }
    
    wait(for: [expectation], timeout: 3)
    
    // Assert
    XCTAssertNotNil(responseError, "An error must be thrown when parsing XML data, but it should not occur for other types of data parsing.")
    switch responseError!.asAFError {
    case .responseSerializationFailed(reason: .decodingFailed(error: let error)):
      if let tourAPIError = error as? TourAPIError {
        switch tourAPIError {
        case .tourAPIProviderInstitutionError(let tourApiProviderError):
          XCTAssertEqual(
            tourApiProviderError,
            .noDataError,
            "Error should return noDataError, but it throwed another case error: \(tourApiProviderError.localizedDescription)")
        default:
          XCTFail("Error should return of type TourAPIError's tourAPIProviderInstitutionError case, but it thorwed another case error:\(error.localizedDescription)")
        }
      } else {
        XCTFail("Error should return of type TourAPIError, but it thorwed unexpected error:\(error.localizedDescription)")
      }
    default:
      XCTFail("Error should return of type ResponseSerializationFailedReason, but it thorwed unexpected error: \(responseError!.localizedDescription)")
    }
  }

}
