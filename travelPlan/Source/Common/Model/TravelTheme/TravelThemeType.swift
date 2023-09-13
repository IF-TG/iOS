//
//  TravelThemeType.swift
//  travelPlan
//
//  Created by 양승현 on 2023/09/13.
//

import Foundation

enum Season: String, CaseIterable {
  case spring = "봄"
  case summer = "여름"
  case fall = "가을"
  case winter = "겨울"
  
  static var count: Int {
    Self.allCases.count
  }
}

enum TravelThemeType: CaseIterable {
  case all
  case season(Season)
  case legion
  case travelTheme
  case partner
  case categoryDevelop
  
  static var allCases: [TravelThemeType] {
    [.all,
     .season(Season.spring),
     .legion,
     .travelTheme,
     .partner,
     .categoryDevelop]
  }
  
  static var count: Int {
    Self.allCases.count
  }
}

extension TravelThemeType: RawRepresentable {
  init?(rawValue: String) {
    switch rawValue {
    case "전체":
      self = .all
    case "계절":
      self = .season(Season.spring)
    case "지역":
      self = .legion
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
    case .legion:
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
