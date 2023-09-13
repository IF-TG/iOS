//
//  TravelCategoryDetailType.swift
//  travelPlan
//
//  Created by 양승현 on 2023/07/10.
//

import Foundation

enum TravelCategoryDetailType: CaseIterable {
  case trend(TravelTrend)
  case travelThemeType(TravelThemeType)
  
  var toIndex: Int {
    switch self {
    case .trend:
      return 0
    case .travelThemeType:
      return 1
    }
  }
  
  static var allCases: [TravelCategoryDetailType] {
    [.trend(.newest),
     .travelThemeType(.all)]
  }
}

// MARK: - RawRepresentable
extension TravelCategoryDetailType: RawRepresentable {
  typealias RawValue = String
  
  init?(rawValue: RawValue) {
    switch rawValue {
    case "전체":
      self = .trend(.newest)
    case "정렬":
      self = .travelThemeType(.all)
    default:
      return nil
    }
  }
  
  var rawValue: RawValue {
    switch self {
    case .trend:
      return "전체"
    case .travelThemeType:
      return "정렬"
    }
  }
}
