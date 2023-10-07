//
//  FavoriteDirectorySettingView.swift
//  travelPlan
//
//  Created by 양승현 on 10/7/23.
//

import UIKit

final class FavoriteDirectorySettingView: UIView {
  enum Constant {
    enum TitleLabel {
      static let height: CGFloat = 51
      enum Spacing {
        static let leading: CGFloat = 27
        static let trailing = leading
      }
    }
    
    enum SearchBar {
      static let height: CGFloat = 69
      enum Spacing {
        static let leading: CGFloat = 30
        static let trailing = leading
      }
    }
    
    enum OkButton {
      static let height: CGFloat = 60
      enum Spacing {
        static let leading: CGFloat = 20
        static let top: CGFloat = 10.5
        static let trailing = leading
        static let bottom = top
      }
    }
  }
}
