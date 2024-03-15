//
//  Double+.swift
//  travelPlan
//
//  Created by SeokHyun on 3/15/24.
//

import Foundation

extension Double {
  func toData() -> Data {
    return withUnsafeBytes(of: self) { pointer in
      return Data(pointer)
    }
  }
}
