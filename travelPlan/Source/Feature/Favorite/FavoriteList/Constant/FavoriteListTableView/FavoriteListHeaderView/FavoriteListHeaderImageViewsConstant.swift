//
//  FavoriteListHeaderImageViewsConstant.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/21.
//

import UIKit

extension FavoriteListHeaderImageViews {
  enum Constant {
    static let itemSpacing: CGFloat = 1
    static let lineSpacing: CGFloat = 1
    enum ImageView {
      static let bgColor: UIColor = .yg.gray1
      static let size = {
        let favoriteListHeaderImageViewWidth = FavoriteListHeaderView
          .Constant
          .ImageViews
          .size
          .width - 1.0
        let width = favoriteListHeaderImageViewWidth / 2.0
        return CGSize(width: width, height: width)
      }()
    }
  }
}
