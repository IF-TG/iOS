//
//  FavoriteViewConstant.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/18.
//

import UIKit

extension FavoriteViewController {
  enum Constant {
    static let bgColor: UIColor = .white
    enum NavigationBar {
      enum Title {
        static let color: UIColor = .yg.gray7
        static let font: UIFont = UIFont(
          pretendard: .semiBold, size: 18)!
      }
      
      enum Setting {
        static let iconName: String = "favoriteNavigationBarSetting"
        static let touchedColor: UIColor = .yg.gray7.withAlphaComponent(0.5)
      }
    }
  }
}
