//
//  CategoryConstant.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/09.
//

import UIKit

// MARK: - CategoryView UI constants
extension CategoryView {
  struct Constant {
    
    struct ScrollBar {
      static let height: CGFloat = 4
      static let radius: CGFloat = 2
      static let color: UIColor = .yg.primary
    }
    
    struct Shadow {
      static let radius: CGFloat = 10.0
      static let color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05).cgColor
      static let offset = CGSize(width: 0, height: 1)
    }
    
    static let cellSize = CategoryViewCell.Constant.size
    
    static let size: CGSize = {
      let width = cellSize.width
      let height = Constant.ScrollBar.height + Constant.cellSize.height
      return CGSize(width: width, height: height)
    }()
  }
}

// MARK: - CategoryViewCell UI constants
extension CategoryViewCell {
  struct Constant {
    struct ImageView {
      struct Spacing {
        static let top: CGFloat = 20
        static let left: CGFloat = 27.5
      }
      static let size: CGSize = CGSize(width: 28, height: 28)
    }
    
    struct Title {
      struct Spacing {
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
  struct Constant {
    struct Spacing {
      static let top: CGFloat = 17.5
    }
  }
}
