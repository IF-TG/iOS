//
//  XCTestCase+Helpers.swift
//  travelPlan
//
//  Created by 양승현 on 4/4/24.
//

import XCTest
import Foundation

// MARK: - Object dealloc
extension XCTestCase {
  public func assertDeallocation<T: AnyObject>(
    _ file: StaticString = #file,
    line: UInt = #line,
    of createObject: () -> T) {
    weak var sutWeakReference: T?
    
    let autoreleaseExpectation = expectation(description: "Autoreleasepool should drain.")
    
    autoreleasepool {
      let strongReferenceObject = createObject()
      
      /// weak reference
      sutWeakReference = strongReferenceObject
      
      XCTAssertNotNil(
        sutWeakReference,
        "Weak reference must hold an instance weakly, but it's nil.",
        file: file,
        line: line)
      autoreleaseExpectation.fulfill()
    }
    
      XCTAssertNil(
        sutWeakReference,
        "Weak reference not released, may be a retain cycle.",
        file: file,
        line: line)
  }
}
