//
//  PostsPage.swift
//  travelPlan
//
//  Created by 양승현 on 3/7/24.
//

import Foundation

struct PostsPage {
  let page: Int
  let perPage: Int
  let category: Category
  let posts: [Post]
}

// MARK: - Nested
extension PostsPage {
  struct Category {
    let mainTheme: TravelMainThemeType
    let orderBy: TravelOrderType
    var subTheme: String? {
      switch mainTheme {
      case .all:
        nil
      case .season(let season):
        season.rawValue
      case .region(let travelRegion):
        travelRegion.rawValue
      case .travelTheme(let travelTheme):
        travelTheme.rawValue
      case .partner(let travelPartner):
        travelPartner.rawValue
      case .categoryDevelop:
        nil
      }
    }
  }
}
