//
//  Season.swift
//  travelPlan
//
//  Created by 양승현 on 2023/09/13.
//

import Foundation

enum Season: String, CaseIterable {
  case spring = "봄"
  case summer = "여름"
  case fall = "가을"
  case winter = "겨울"
}

// MARK: - Mappings toDTO
extension Season {
  func toDTO() -> String {
    return switch self {
    case .spring:
      "SPRING"
    case .summer:
      "SUMMER"
    case .fall:
      "AUTUMN"
    case .winter:
      "WINTER"
    }
  }
}
