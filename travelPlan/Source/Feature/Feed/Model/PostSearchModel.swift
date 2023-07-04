//
//  PostSearchSectionItemModel.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/10.
//

import Foundation

struct PostSearchSectionItemModel {
  let type: SectionType
  var items: [String]
}

// MARK: - SectionType
extension PostSearchSectionItemModel {
  enum SectionType: Int, CaseIterable {
    case recommendation // 추천
    case recent // 최근
  }
}

// MARK: - Properties
extension PostSearchSectionItemModel.SectionType {
  var headerTitle: String {
    switch self {
    case .recommendation:
      return "추천 검색"
    case .recent:
      return "최근 검색"
    }
  }
}
