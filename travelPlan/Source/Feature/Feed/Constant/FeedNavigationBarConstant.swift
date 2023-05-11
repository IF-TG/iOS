//
//  FeedNavigationBarConstant.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/10.
//

import UIKit

extension FeedNavigationBar {
  struct Constant {
    struct Title {
      static let text = "ㅇㅕ ㄱㄴ"
      static let textColor: UIColor = .yg.primary
      static let fontSize: CGFloat = 18
      static let leadingSpacing: CGFloat = 30
      static let topSpacing: CGFloat = 10
      static let bottomSpacing: CGFloat = 10
    }
    struct UserPostSearch {
      static let image = UIImage()
      static let size = CGSize(width: 24, height: 24)
      static let trailingSpacing: CGFloat = 19.3
      static let topSpacing: CGFloat = 10.5
      static let bottomSpacing: CGFloat = 10.5
      static let normalColor: UIColor = .yg.gray5
      static let highlightColor: UIColor = .yg.gray5.withAlphaComponent(0.5)
    }
    
    struct Notification {
      static let image = UIImage()
      static let size = CGSize(width: 24, height: 24)
      static let trailingSpacing: CGFloat = 23.8
      static let topSpacaing: CGFloat = 9.33
      static let bottomSpacing: CGFloat = 9.33
      static let normalColor: UIColor = .yg.gray5
      static let highlightColor: UIColor = .yg.gray5.withAlphaComponent(0.5)
    }
  }
}
