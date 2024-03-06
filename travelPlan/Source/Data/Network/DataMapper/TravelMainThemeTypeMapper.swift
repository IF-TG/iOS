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
      ""
    case .season(let season):
      SeasonMapper.toDTO(season)
    case .region(let region):
      TravelRegionMapper.toDTO(region)
    case .travelTheme(let theme):
      TravelThemeMapper.toDTO(theme)
    case .partner(let partner):
      TravelPartnerMapper.toDTO(partner)
    case .categoryDevelop:
      ""
    }
  }
}
