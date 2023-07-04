//
//  MoreCategoryType.swift
//  travelPlan
//
//  Created by 양승현 on 2023/07/04.
//

enum MoreCategoryType {
  case total
  case sorting
  
  var toString: String {
    switch self {
    case .sorting: return "정렬"
    case .total: return "전체"
    }
  }
}
