//
//  Notification+.swift
//  travelPlan
//
//  Created by 양승현 on 2023/07/03.
//

import Foundation

/// PostViewDetailCategoryHeaderView -> FeedViewController로 이벤트 전달 하기 위한 식별자
extension Notification.Name {
  static let postViewDetailCategoryHeaderViewToFeedVC = Notification.Name(
    "PostViewDetailCategoryHeaderViewToFeedVC")
}
