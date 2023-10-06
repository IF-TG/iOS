//
//  Int+.swift
//  travelPlan
//
//  Created by 양승현 on 10/4/23.
//

import Foundation

extension Int {
  /// 한글자의 숫자를 문자열로 변환할 때 01, 02 ... 이렇게 변합니다
  var zeroPaddingString: String {
    return String(format: "%02d", self)
  }
}
