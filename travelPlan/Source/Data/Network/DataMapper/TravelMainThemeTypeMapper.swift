//
//  TravelMainThemeTypeMapper.swift
//  travelPlan
//
//  Created by 양승현 on 3/7/24.
//

import Foundation

struct TravelMainThemeTypeMapper {
  static func toMainCategoryDTO(_ requestValue: TravelMainThemeType) -> String {
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
  
  static func toSubCategoryDTO(_ requestValue: TravelMainThemeType) -> String? {
    return switch requestValue {
    case .all:
      nil
    case .season(let season):
      SeasonMapper.toDTO(season)
    case .region(let travelRegion):
      TravelRegionMapper.toDTO(travelRegion)
    case .travelTheme(let travelTheme):
      TravelThemeMapper.toDTO(travelTheme)
    case .partner(let travelPartner):
      TravelPartnerMapper.toDTO(travelPartner)
    case .categoryDevelop:
      nil
    }
  }
}
