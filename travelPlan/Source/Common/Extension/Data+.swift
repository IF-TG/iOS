//
//  Data+.swift
//  travelPlan
//
//  Created by SeokHyun on 3/15/24.
//

import Foundation

extension Data {
  /// Double? 타입으로 변환 후 반환합니다.
  func toDouble() -> Double? {
    return self.withUnsafeBytes { pointer in
      guard pointer.count >= MemoryLayout<Double>.size else { return nil }
      return pointer.load(as: Double.self)
    }
  }
  
  /// Int? 타입으로 변환 후 반환합니다.
  func toInt() -> Int? {
    return self.withUnsafeBytes { pointer in
      guard pointer.count >= MemoryLayout<Int>.size else { return nil }
      return pointer.load(as: Int.self)
    }
  }
}
