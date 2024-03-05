//
//  TravelMainThemeType.swift
//  travelPlan
//
//  Created by 양승현 on 2023/09/13.
//

import Foundation

enum TravelMainThemeType: CaseIterable {
  case all
  case season(Season)
  case region(TravelRegion)
  case travelTheme(TravelTheme)
  case partner(TravelPartner)
  case categoryDevelop
  
  static var allCases: [TravelMainThemeType] {
    [.all,
     .season(Season.spring),
     .region(TravelRegion.busan),
     .travelTheme(TravelTheme.local),
     .partner(TravelPartner.alone),
     .categoryDevelop]
  }
  
  var titles: [String] {
    switch self {
    case .all:
      return []
    case .season:
      return Season.allCases.map { $0.rawValue }
    case .region:
      return TravelRegion.allCases.map { $0.rawValue }
    case .travelTheme:
      return TravelTheme.allCases.map { $0.rawValue }
    case .partner:
      return TravelPartner.allCases.map { $0.rawValue }
    case .categoryDevelop:
      return []
    }
  }
  
  var imagePath: String {
    switch self {
    case .all:
      return "travelCategoryAll"
    case .season:
      return "travelCategorySeason"
    case .region:
      return "travelCategoryRegion"
    case .travelTheme:
      return "travelCategoryTravelTheme"
    case .partner:
      return  "travelCategoryPartner"
    case .categoryDevelop:
      return "travelCategoryDevelop"
    }
  }
}

// MARK: - RawRepresentable
extension TravelMainThemeType: RawRepresentable {
  init?(rawValue: String) {
    switch rawValue {
    case "전체":
      self = .all
    case "계절":
      self = .season(Season.spring)
    case "지역":
      self = .region(TravelRegion.busan)
    case "여행 테마":
      self = .travelTheme(TravelTheme.adventure)
    case "동반자":
      self = .partner(TravelPartner.alone)
    case "???":
      self = .categoryDevelop
    default:
      return nil
    }
  }
  
  var rawValue: String {
    switch self {
    case .all:
      return "전체"
    case .season:
      return "계절"
    case .region:
      return "지역"
    case .travelTheme:
      return "여행 테마"
    case .partner:
      return "동반자"
    case .categoryDevelop:
      return "???"
    }
  }
}

// MARK: - Mappings toDTO
extension TravelMainThemeType {
  func toDTO() -> String {
    return switch self {
    case .all:
      ""
    case .season(let season):
      season.toDTO()
    case .region(let region):
      region.toDTO()
    case .travelTheme(let theme):
      theme.toDTO()
    case .partner(let partner):
      partner.toDTO()
    case .categoryDevelop:
      ""
    }
  }
}
