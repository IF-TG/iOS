//
//  PostFilterOptions.swift
//  travelPlan
//
//  Created by 양승현 on 2023/07/10.
//

import Foundation

@frozen enum PostFilterOptions {
  case travelOrder
  case travelMainTheme(TravelMainThemeType)
  
  var rawValue: String {
    switch self {
    case .travelOrder:
      return "정렬"
    case .travelMainTheme:
      return "분류"
    }
  }
}
