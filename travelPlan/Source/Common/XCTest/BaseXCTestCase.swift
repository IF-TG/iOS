//
//  BaseXCTestCase.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/20/24.
//

import XCTest
import Combine
import Foundation

/// BaseXCTestCase
///
/// This base class provides a common setup and teardown for XCTest cases.
///
/// Subclasses must override the `setUp` and `tearDown` methods to ensure proper test execution.
class BaseXCTestCase: XCTestCase {
  /// 비동기 처리할 때 Expectation을 관리하는 프로퍼티 입니다.
  var expectation: XCTestExpectation!
  var subscriptions = Set<AnyCancellable>()
  
  /// 테스트 결과 예상치 못한 에러를 받았을때 사용됩니다.
  var unexpectedError: Error?
  
  /// 테스트 결과를 받았는지 여부는 이 변수를 통해 확인합니다.
  var hasReceivedResult: Bool = false
  
  /// hasReceivedResult를 받았어야 하지만 받지 못했을때 실패 메시지를 출력합니다.
  /// 실패 메시지는 직접 지정할 수 있습니다.
  var expectedResultNotReceivedMessage: String {
    get { notReceivedErrorMessage
    } set {
      defaultExpectedResultNotReceivedMessage = newValue
    }
  }
  
  private lazy var defaultExpectedResultNotReceivedMessage: String = notReceivedErrorMessage
  
  override func setUp() {
    super.setUp()
    expectation = XCTestExpectation(description: "유닛 테스트 시작합니다.")
    unexpectedError = nil
    hasReceivedResult = false
    defaultExpectedResultNotReceivedMessage = notReceivedErrorMessage
  }
  
  override func tearDown() {
    super.tearDown()
    expectation = nil
    unexpectedError = nil
    hasReceivedResult = false
    defaultExpectedResultNotReceivedMessage = ""
  }
}
