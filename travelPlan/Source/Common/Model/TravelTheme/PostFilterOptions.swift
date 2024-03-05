//
//  PostFilterOptions.swift
//  travelPlan
//
//  Created by 양승현 on 2023/07/10.
//

import Foundation

enum PostFilterOptions {
  case travelOrder
  case travelMainTheme(TravelMainThemeType)
  
  var toIndex: Int {
    switch self {
    case .travelOrder:
      return 0
    case .travelMainTheme:
      return 1
    }
  }
  
  var subCateogryTitles: [String] {
    switch self {
    case .travelOrder:
      /// 인기순 최신순
      return TravelOrderType.allCases.map { $0.rawValue }
    case .travelMainTheme(let travelThemeType):
      /// 지역일 경우 서울,  경기 ... 17개
      return travelThemeType.titles
    }
  }
}

// MARK: - RawRepresentable
extension PostFilterOptions: RawRepresentable {
  init?(rawValue: String) {
    switch rawValue {
    case "최신순":
      self = .travelOrder
    case "분류":
      self = .travelMainTheme(.all)
    default:
      return nil
    }
  }
  
  var rawValue: String {
    switch self {
    case .travelOrder:
      return "최신순"
    case .travelMainTheme:
      return "분류"
    }
  }
  
}
