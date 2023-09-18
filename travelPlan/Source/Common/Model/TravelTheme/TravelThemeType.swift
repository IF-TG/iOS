//
//  TravelThemeType.swift
//  travelPlan
//
//  Created by 양승현 on 2023/09/13.
//

import Foundation

enum TravelThemeType: CaseIterable {
  case all
  case season(Season)
  case region(TravelRegion)
  case travelTheme(TravelTheme)
  case partner(TravelPartner)
  case categoryDevelop
  
  static var allCases: [TravelThemeType] {
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
}

// MARK: - RawRepresentable
extension TravelThemeType: RawRepresentable {
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
