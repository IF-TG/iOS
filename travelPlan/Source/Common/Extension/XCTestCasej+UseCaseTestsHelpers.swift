//
//  XCTestCasej+UseCaseTestsHelpers.swift
//  travelPlan
//
//  Created by 양승현 on 3/27/24.
//

import XCTest

extension XCTestCase {
  /// 테스트하다 에러가 발생된 경우 해당 에러를 출력합니다.
  func checkIfUnexpectedErrorOccurred(_ error: Error?, functionName: String) {
    guard let error = error else { return }
    XCTAssert(
      false,
            """
            \(functionName) 함수 호출시 에러가 발생되었습니다.
            Occurred error description: \(error.localizedDescription)
            """
    )
  }
  
  /// 엔터티를 받아야하지만 엔터티를 받지 못할 경우 이 문구를 디버그창에 출력합니다.
  var notReceivedErrorMessage: String {
    "Entity를 받아야 하지만 upstream이 종료되었습니다."
  }
}
