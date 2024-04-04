//
//  SHCoordinator+XCTestCase.swift
//  travelPlanTests
//
//  Created by 양승현 on 4/4/24.
//

import XCTest
import Foundation
import SHCoordinator

// MARK: - SHCoordinator+XCTestCase
extension XCTestCase {
  
  /// 이 함수로 코디네이터의 start, dismiss 후 memory leak를 체크하려면
  /// navigationController(_: didShow: animated:) 를 준수해야 합니다.
  public func assertCoordinatorDeallocation<Coordinator: FlowCoordinator & FlowCoordinatorNavigatable>(
    _ file: StaticString = #file,
    line: UInt = #line,
    of createCoordinator: () -> Coordinator
  ) {
    weak var weakCoordinator: Coordinator?
    
    let autoreleaseExpectation = expectation(description: "Autoreleasepool should drain.")
    
    autoreleasepool {
      let strongCoordinator = createCoordinator()
      
      weakCoordinator = strongCoordinator
      XCTAssertNotNil(
        weakCoordinator,
        "Weak reference must hold an instance weakly, but it's nil.",
        file: file,
        line: line)
      weakCoordinator?.start()
      
      // Delayed dismissal after 1 second
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        weakCoordinator?.presenter?.popViewController(animated: false)
        autoreleaseExpectation.fulfill()
      }
      wait(for: [autoreleaseExpectation], timeout: 3)
    }
    XCTAssertNil(
      weakCoordinator,
      "Weak reference not released, may be a retain cycle.",
      file: file,
      line: line)
  }
}
