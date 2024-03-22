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
    switch requestValue {
    case .all:
      return nil
    case .season(let season):
      guard let season else { return nil }
      return SeasonMapper.toDTO(season)
    case .region(let travelRegion):
      guard let travelRegion else { return nil }
      return TravelRegionMapper.toDTO(travelRegion)
    case .travelTheme(let travelTheme):
      guard let travelTheme else { return nil }
      return TravelThemeMapper.toDTO(travelTheme)
    case .partner(let travelPartner):
      guard let travelPartner else { return nil }
      return TravelPartnerMapper.toDTO(travelPartner)
    case .categoryDevelop:
      return nil
    }
  }
}
