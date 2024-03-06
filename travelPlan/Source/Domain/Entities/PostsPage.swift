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
  }
}
