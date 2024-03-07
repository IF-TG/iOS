//
//  TravelMainThemeTypeMapper.swift
//  travelPlan
//
//  Created by 양승현 on 3/7/24.
//

import Foundation

struct TravelMainThemeTypeMapper {
  static func toDTO(_ requestValue: TravelMainThemeType) -> String {
    return switch requestValue {
    case .all:
      "ORIGINAL"
    case .season(_):
      "SEASON"
    case .region(_):
      "REGION"
    case .travelTheme(_):
      "THEME"
    case .partner(_):
      "COMPANION"
    case .categoryDevelop:
      ""
    }
  }
}
