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
}

// MARK: - SectionType
extension SearchSectionItemModel {
  enum SectionType: Int, CaseIterable {
    case recommendation // 추천
    case recent // 최근
  }
}

// MARK: - ComputedProperties in SectionType
extension SearchSectionItemModel.SectionType {
  var title: String {
    switch self {
    case .recommendation:
      return "추천 검색"
    case .recent:
      return "최근 검색"
    }
  }
  
  var index: Int {
    switch self {
    case .recommendation:
      return self.rawValue
    case .recent:
      return self.rawValue
    }
  }
}
