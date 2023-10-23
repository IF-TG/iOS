//
//  TravelCategorySortingType.swift
//  travelPlan
//
//  Created by 양승현 on 2023/07/10.
//

import Foundation

enum TravelCategorySortingType {
  case trend
  case detailCategory(TravelMainThemeType)
  
  var toIndex: Int {
    switch self {
    case .trend:
      return 0
    case .detailCategory:
      return 1
    }
  }
  
  var subCateogryTitles: [String] {
    switch self {
    case .trend:
      /// 인기순 최신순
      return TravelOrderType.allCases.map { $0.rawValue }
    case .detailCategory(let travelThemeType):
      /// 지역일 경우 서울,  경기 ... 17개
      return travelThemeType.titles
    }
  }
}

// MARK: - RawRepresentable
extension TravelCategorySortingType: RawRepresentable {
  init?(rawValue: String) {
    switch rawValue {
    case "최신순":
      self = .trend
    case "분류":
      self = .detailCategory(.all)
    default:
      return nil
    }
  }
  
  var rawValue: String {
    switch self {
    case .trend:
      return "최신순"
    case .detailCategory:
      return "분류"
    }
  }
  
}
