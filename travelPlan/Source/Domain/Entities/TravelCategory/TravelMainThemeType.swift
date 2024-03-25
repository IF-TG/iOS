//
//  TravelMainThemeType.swift
//  travelPlan
//
//  Created by 양승현 on 2023/09/13.
//

import Foundation

@frozen enum TravelMainThemeType: CaseIterable {
  case all
  case season(Season?)
  case region(TravelRegion?)
  case travelTheme(TravelTheme?)
  case partner(TravelPartner?)
  case categoryDevelop
  
  static var allCases: [TravelMainThemeType] {
    [.all,
     .season(nil),
     .region(nil),
     .travelTheme(nil),
     .partner(nil),
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
      self = .season(nil)
    case "지역":
      self = .region(nil)
    case "여행 테마":
      self = .travelTheme(nil)
    case "동반자":
      self = .partner(nil)
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
