//
//  PostSearchSectionItemModel.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/10.
//

import Foundation

struct PostSearchSectionModel {
  var sectionItem: Item
  let section: Section
  
  enum Item {
    case recommendation(items: [String])
    case recent(items: [String])
    
    
  }
  
  enum Section {
    case recommendation(title: String)
    case recent(title: String)
  }
}

extension PostSearchSectionModel.Item: Equatable {
  static func == (
    lhs: PostSearchSectionModel.Item,
    rhs: PostSearchSectionModel.Item
  ) -> Bool {
    switch (lhs, rhs) {
    case (.recommendation, .recommendation):
      return true
    case (.recent, .recent):
      return true
    default:
      return false
    }
  }
}

// MARK: - Mock
extension PostSearchSectionModel {
  static func createRecommendationMock() -> [String] {
    return ["인기관광", "가족코스", "자연", "추천444444", "추천5", "추천66", "추천7777"]
  }
  
  static func createRecentMock() -> [String] {
    return ["부산여행부산여행부산여행부산여행부산여행부산여행부산여행부산여행부산여행부산여행", "국내여행", "맛집", "카페", "기타"]
  }
  
  static func createHeaderMock() -> [String] {
    return ["추천 검색", "최근 검색"]
  }
  
  static func createRecommendationHeaderMock() -> String {
    return "추천 검색"
  }
  
  static func createRecentHeaderMock() -> String {
    return "최근 검색"
  }
}
