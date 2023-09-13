//
//  TravelCategorySortingType.swift
//  travelPlan
//
//  Created by 양승현 on 2023/07/10.
//

import Foundation

enum TravelCategorySortingType: String {
  case trend = "전체"
  case detailCategory = "정렬"
  
  var toIndex: Int {
    switch self {
    case .trend:
      return 0
    case .detailCategory:
      return 1
    }
  }
}
