//
//  NumberFormatterWithSuffix.swift
//  travelPlan
//
//  Created by 양승현 on 6/20/24.
//

import Foundation

/// 숫자를 1K -> 1 M등으로 변환해주는 객체입니다.
struct NumberFormatterWithSuffix {
  private init() {}
  static func format(number: Int) -> String {
    if number >= 1_000_000 {
      let formattedNumber = Double(number) / 1_000_000
      return String(format: "%.1fM", formattedNumber)
    } else if number >= 1_000 {
      let formattedNumber = Double(number) / 1_000
      return String(format: "%.1fK", formattedNumber)
    } else {
      return "\(number)"
    }
  }
}
