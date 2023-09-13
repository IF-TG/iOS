//
//  Notification+.swift
//  travelPlan
//
//  Created by 양승현 on 2023/09/13.
//

import Foundation

extension Notification.Name {
  /// FeedPage에서 정렬, 소정렬 눌렀을 때
  static let TravelCategoryDetailSelected = Notification
    .Name("travelCategoryDetailSelected")
  
  /// PostViewDetailCategoryHeaderView -> FeedViewController로 이벤트 전달 하기 위한 식별자
  static let postViewDetailCategoryHeaderViewToFeedVC = Notification.Name(
    "PostViewDetailCategoryHeaderViewToFeedVC")
}
