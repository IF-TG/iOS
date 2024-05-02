//
//  Double+.swift
//  travelPlan
//
//  Created by SeokHyun on 3/15/24.
//

import Foundation

extension Double {
  /// Data 타입으로 변환 후 반환합니다.
  func toData() -> Data {
    return withUnsafeBytes(of: self) { pointer in
      return Data(pointer)
    }
  }
}
