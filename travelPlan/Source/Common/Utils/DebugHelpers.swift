//
//  DebugHelpers.swift
//  travelPlan
//
//  Created by 양승현 on 6/6/24.
//

import Foundation

public func memoryAddress<Object>(_ object: Object) {
#if DEBUG
  if type(of: object) is AnyObject.Type {
    print("\(object)'s address is: ", Unmanaged.passUnretained(object as AnyObject).toOpaque())
  } else {
    withUnsafePointer(to: object) {
      print("\(object)'s address is: ", $0)
    }
  }
#endif
}
