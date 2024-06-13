//
//  PostOptionLocation.swift
//  travelPlan
//
//  Created by 양승현 on 6/7/24.
//

import Foundation

@frozen enum PostOptionLocation: Equatable {
  /// 피드화면
  /// 이 경우 어느 카테고리인지 식별하지 않을 경우 모든 카테고리에서 동일하게 적용됨으로.
  /// 특정 카테고리임을 식별해야 합니다.
  case summaryPage(TravelMainThemeType?)
  /// 상세 화면
  case detailPage
  
  static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.rawValue == rhs.rawValue
  }
}

extension PostOptionLocation: RawRepresentable {
  typealias RawValue = String
  init?(rawValue: String) {
    if rawValue == "summaryPage" {
      self = .summaryPage(nil)
    } else if rawValue == "detailPage" {
      self = .detailPage
    }
    return nil
  }
  
  var rawValue: String {
    switch self {
    case .detailPage:
      return "detailPage"
    case .summaryPage:
      return "summaryPage"
    }
  }
}
