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
    case .season:
      "SEASON"
    case .region:
      "REGION"
    case .travelTheme:
      "THEME"
    case .partner:
      "COMPANION"
    case .categoryDevelop:
      ""
    }
  }
  
  /// firestore에 저장된 main theme의 필드들입니다.
  static func toFirestoreField(_ from: TravelMainThemeType) -> String? {
    return switch from {
    case .season:
      "seasons"
    case .region:
      "regions"
    case .travelTheme:
      "themes"
    case .partner:
      "companions"
    default:
      nil
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
