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
/// 결과가 성공이든 에러든 expectation.fulfill()을 호출합니다.
/// expectation을 방출하기 전에 sink의 receivedValue를 받았는지, 아니면 에러를 받았는지를 resultHandler의 인자값으로 알수있습니다.
extension XCTestCase {
  typealias UnexpectedError = Error
  typealias HasReceivedResult = Bool
  typealias TestResultHandler = (UnexpectedError?, HasReceivedResult) -> Void
  
  func sink(
    fromPublisher taskPublisher: any Publisher,
    withExpectation expectation: XCTestExpectation,
    resultHandler: @escaping TestResultHandler
  ) -> AnyCancellable {
    return taskPublisher
      .sink(
        withExpectation: expectation,
        resultHandler: resultHandler)
  }
}

fileprivate extension Publisher {
  typealias UnexpectedError = Error
  typealias HasReceivedResult = Bool
  typealias TestResultHandler = (UnexpectedError?, HasReceivedResult) -> Void
  
  func sink(
    withExpectation expectation: XCTestExpectation,
    resultHandler: @escaping TestResultHandler
  ) -> AnyCancellable {
    return self
      .receive(on: DispatchQueue.main)
      .sink { completion in
      if case .failure(let error) = completion {
        resultHandler(error, false)
        expectation.fulfill()
      }
    } receiveValue: { receivedValue in
      _ = print("DEBUG: 값을 성공적으로 받았습니다:\n\(receivedValue)\n\n")
      resultHandler(nil, true)
      expectation.fulfill()
    }
  }
}
#endif
