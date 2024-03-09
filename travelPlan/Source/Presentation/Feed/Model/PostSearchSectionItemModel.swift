//
//  PostSearchSectionItemModel.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/10.
//

import Foundation

enum PostSearchSection: Int {
  case recommendation
  case recent
}

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
    return ["인기관광", "가족코스", "자연", "액티비티", "TOP10 여행지", "인기맛집", "대전 명소"]
  }
  
  static func createRecentMock() -> [String] {
    return ["부산여행", "국내여행", "대청호", "카페", "기타", "대전 동구 맛집", "맛집"]
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
