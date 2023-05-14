//
//  FeedNavigationBarConstant.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/10.
//

import UIKit

extension FeedNavigationBar {
  enum Constant {
    static let backgroundColor: UIColor = .white
    enum Title {
      static let text = "ㅇㅕ ㄱㄴ"
      static let textColor: UIColor = .yg.primary
      static let fontSize: CGFloat = 18
      static let leadingSpacing: CGFloat = 30
      static let topSpacing: CGFloat = 10
      static let bottomSpacing: CGFloat = 10
      static let fontName: String = "SFProText-Semibold"
    }
    enum postSearch {
      static let image = UIImage(named: "search")
      static let size = CGSize(width: 24, height: 24)
      static let trailingSpacing: CGFloat = 19.3
      static let topSpacing: CGFloat = 10.5
      static let bottomSpacing: CGFloat = 10.5
      static let normalColor: UIColor = .yg.gray5
      static let highlightColor: UIColor = .yg.gray5.withAlphaComponent(0.5)
    }
    enum Notification {
      static let image = UIImage(named: "notification")
      static let size = CGSize(width: 24, height: 24)
      static let topSpacaing: CGFloat = 9.33
      static let bottomSpacing: CGFloat = 9.33
      static let normalColor: UIColor = .yg.gray5
      static let highlightColor: UIColor = .yg.gray5.withAlphaComponent(0.5)
    }
    enum NotificationIcon {
      static let width: CGFloat = 5
      static let height: CGFloat = 5
      static let topSpacing: CGFloat = 9.33
      static let trailingSpacing: CGFloat = 23.8 - width
      static let color: UIColor = UIColor(hex: "#FF2216")
    }
  }
}
