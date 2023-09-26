//
//  CategoryConstant.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/09.
//

import UIKit

// MARK: - CategoryViewCell UI constants
extension CategoryViewCell {
  enum Constant {
    enum ImageView {
      enum Spacing {
        static let top: CGFloat = 20
        static let left: CGFloat = 27.5
      }
      static let size: CGSize = CGSize(width: 28, height: 28)
    }
    enum Title {
      enum Spacing {
        static let top: CGFloat = 5
        static let bottom: CGFloat = 6
      }
      static let fontSize: CGFloat = 12
      static let height: CGFloat = 22
      static let textColor = UIColor(red: 0.404, green: 0.404, blue: 0.404, alpha: 1)
    }
    static let size: CGSize = {
      let width = Constant.ImageView.Spacing
        .left * 2.0 + ImageView.size.width
      let height = Constant.ImageView.Spacing.top +
      Constant.ImageView.size.height +
      Constant.Title.Spacing.top +
      Constant.Title.height +
      Constant.Title.Spacing.bottom
      return CGSize(width: width, height: height)
    }()
  }
}

// MARK: - CategoryDetailViewCell UI constants
extension CategoryDetailViewCell {
  enum Constant {
    enum Spacing {
      static let top: CGFloat = 0
    }
  }
}
