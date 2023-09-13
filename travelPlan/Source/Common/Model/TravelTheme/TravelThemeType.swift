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
  case region
  case travelTheme
  case partner
  case categoryDevelop
  
  static var allCases: [TravelThemeType] {
    [.all,
     .season(Season.spring),
     .region,
     .travelTheme,
     .partner,
     .categoryDevelop]
  }
  
  static var count: Int {
    Self.allCases.count
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
      self = .region
    case "여행 테마":
      self = .travelTheme
    case "동반자":
      self = .partner
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
    case .season(_):
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
