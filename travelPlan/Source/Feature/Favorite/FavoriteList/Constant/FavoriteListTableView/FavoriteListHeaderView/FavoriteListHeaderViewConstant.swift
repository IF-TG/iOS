//
//  FavoriteListTotalViewConstant.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/20.
//

import UIKit

extension FavoriteListHeaderView {
  enum Constant {
    enum ImageViews {
      static let spacing = UISpacing(leading: 20, top: 15, bottom: 16)
      static let size = CGSize(width: 40, height: 40)
    }
    
    enum Title {
      static let spacing = UISpacing(leading: 15, trailing: 43)
      static let textColor: UIColor = .yg.gray6
      static let fontName: UIFont.Pretendard = .medium
      static let textSize: CGFloat = 15.0
    }
  }
}
