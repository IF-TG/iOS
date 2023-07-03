//
//  MoreCategoryViewConstant.swift
//  travelPlan
//
//  Created by 양승현 on 2023/07/03.
//

import UIKit

extension MoreCategoryView {
  struct Constant {
    static let color: UIColor = .YG.gray0
    static let boarderSize: CGFloat = 0.8
    static let radius: CGFloat = 15
    
    enum MoreIcon {
      static let spacing: UISpacing = .init(
        leading: 3, top: 5, trailing: 10, bottom: 5)
      static let size: CGSize = .init(
        width: 20, height: 20)
      static let iconName = "feedMore"
    }
    
    enum CategoryLabel {
      static let spacing: UISpacing = .init(
        leading: 10, top: 7, bottom: 7)
      static let fontSize: CGFloat = 13
      static let color: UIColor = .YG.gray6
      
    }
    
  }
}
