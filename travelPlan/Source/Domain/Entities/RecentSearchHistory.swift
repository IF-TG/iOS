//
//  RecentSearchHistory.swift
//  travelPlan
//
//  Created by SeokHyun on 7/18/24.
//

import Foundation

struct RecentSearchHistory {
  let keyword: String
  let createAt: Date?
}

extension RecentSearchHistory: Comparable {
  static func < (
    lhs: RecentSearchHistory,
    rhs: RecentSearchHistory
  ) -> Bool {
    switch (lhs.createAt, rhs.createAt) {
    case let (left?, right?):
      return left < right
    case (nil, _):
      return false
    case (_, nil):
      return true
    }
  }
  
  static func == (
    lhs: RecentSearchHistory,
    rhs: RecentSearchHistory
  ) -> Bool {
    return lhs.createAt == rhs.createAt
  }
}
