//
//  FeedRightNaviContentViewCostant.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/16.
//

import UIKit

// MARK: - FeedPostDearchBarItem
extension FeedPostSearchBarItem {
  enum Constant {
    static let backgroundColor: UIColor = .white
    static let image = UIImage(named: "search")
    static let size = CGSize(width: 24, height: 24)
    enum Inset {
      static let top: CGFloat = 5
      static let bottom: CGFloat = 5
      static let leading: CGFloat = 0
      static let trailing: CGFloat = 0
    }
    static let normalColor: UIColor = .yg.gray5
    static let highlightColor: UIColor = .yg.gray5.withAlphaComponent(0.5)
  }
}

// MARK: - FeedNotificationBarItem
extension FeedNotificationBarItem {
  enum Constant {
    static let backgroundColor: UIColor = .white
    enum Notification {
      static let image = UIImage(named: "notification")
      static let size = CGSize(width: 24, height: 24)
      enum Inset {
        static let top: CGFloat = 9.33
        static let bottom: CGFloat = 9.33
        static let leading: CGFloat = 10.33
        static let trailing: CGFloat = 10
      }
      static let topSpacaing: CGFloat = 9.33
      static let bottomSpacing: CGFloat = 9.33
      static let normalColor: UIColor = .yg.gray5
      static let highlightColor: UIColor = .yg.gray5.withAlphaComponent(0.5)
    }
    enum NotificationIcon {
      static let width: CGFloat = 5
      static let height: CGFloat = 5
      static let topSpacing: CGFloat = 9.33
      static let trailingSpacing: CGFloat = 5
      static let color: UIColor = UIColor(hex: "#FF2216")
    }
  }
}

// MARK: - FeedAppTitleBarItem
extension FeedAppTitleBarItem {
  enum Constant {
    static let backgroundColor: UIColor = .white
    static let size = CGSize(width: 24, height: 24)
    enum Image {
      static let text = "appLogo"
    }
    enum Spacing {
      static let top: CGFloat = 10
      static let bottom: CGFloat = 0
      static let leading: CGFloat = 15
      static let trailing: CGFloat = 0
    }
  }
}
