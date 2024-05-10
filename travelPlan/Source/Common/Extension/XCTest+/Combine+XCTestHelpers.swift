//
//  Combine+XCTestHelpers.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/10/24.
//

import Foundation
import Combine

#if canImport(XCTest) && os(iOS) && swift(>=5.0) && targetEnvironment(simulator)
import XCTest

/// 비동기적으로 작동하는 퍼블리셔로부터 데이터를 잘 받았는지, 에러를 방출하는지를 구독하는 함수입니다.
extension XCTestCase {
  func sink(
    fromPublisher taskPublisher: any Publisher,
    withExpectation expectation: XCTestExpectation,
    unexpectedError: inout Error?,
    hasReceivedResult: inout Bool
  ) -> AnyCancellable {
    return taskPublisher
      .sink(
        withExpectation: expectation,
        unexpectedError: &unexpectedError,
        hasReceivedResult: &hasReceivedResult)
  }
}

fileprivate extension Publisher {
  func sink(
    withExpectation expectation: XCTestExpectation,
    unexpectedError: inout Error?,
    hasReceivedResult: inout Bool
  ) -> AnyCancellable {
    return self
      .receive(on: DispatchQueue.main)
      .sink { completion in
      if case .failure(let error) = completion {
        unexpectedError = error
        expectation.fulfill()
      }
    } receiveValue: { receivedValue in
      NSLog("DEBUG: 값을 성공적으로 받았습니다:\n\(receivedValue)\n\n")
      hasReceivedResult = true
      expectation.fulfill()
    }
  }
}
#endif
