//
//  RecommendationSearchTagModel.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/10.
//

import Foundation

struct SearchSectionItemModel {
  let type: SectionType
  var items: [String]
  
  enum SectionType: Int, CaseIterable {
    case recommendation
    case recent
    
    var title: String {
      switch self {
      case .recommendation:
        return "추천 검색"
      case .recent:
        return "최근 검색"
      }
    }
  }
}
