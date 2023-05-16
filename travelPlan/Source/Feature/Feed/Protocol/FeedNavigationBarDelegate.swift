//
//  FeedNavigationBarDelegate.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/10.
//

protocol FeedPostSearchBarItemDelegate: AnyObject {
  func didTapPostSearch()
}

protocol FeedNotificationBarItemDelegate: AnyObject {
  func didTapNotification()
}

protocol FeedNavigationBarDelegate: FeedPostSearchBarItemDelegate, FeedNotificationBarItemDelegate { }
