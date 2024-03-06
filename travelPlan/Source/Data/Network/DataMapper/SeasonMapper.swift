//
//  SeasonMapper.swift
//  travelPlan
//
//  Created by 양승현 on 3/7/24.
//

import Foundation

struct SeasonMapper {
  static func fromDTO(_ dto: String) -> Season? {
    return switch dto {
    case "SPRING":
        .spring
    case "SUMMER":
        .summer
    case "AUTUMN":
        .fall
    case "WINTER":
        .winter
    default:
      nil
    }
  }
  
  static func toDTO(_ requestValue: Season) -> String {
    return switch requestValue {
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
