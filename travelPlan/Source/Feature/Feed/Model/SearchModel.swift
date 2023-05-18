//
//  RecommendationSearchTagModel.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/10.
//

import Foundation

// ModelingFIXME: - Section과 Item Modeling
struct SearchSectionItemModel {
  enum SearchSection {
    case recommendation
    case recent
  }
}

struct RecommendationSearch {
  let headerTitle = "추천 검색"
  let keywords = [
    "추천1", "추천22", "추천33333", "추천444"
  ]
}

struct RecentSearch {
  let headerTitle = "최근 검색"
  let keywords = [
    "최근검색2222zzzzzzzzzzz", "최근검색22", "최근검색3333", "최근검색", "최근검색5"
  ]
}
