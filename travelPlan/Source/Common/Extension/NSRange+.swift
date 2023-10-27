//
//  NSRange+.swift
//  travelPlan
//
//  Created by SeokHyun on 10/28/23.
//

import Foundation

extension NSRange {
  /// 해당 범위의 문자열이 유효한지 판별하는 프로퍼티입니다.
  /// 유효하다면 self를, 유효하지 않다면 nil을 반환합니다.
  var validation: NSRange? {
    return location != NSNotFound ? self : nil
  }
}
