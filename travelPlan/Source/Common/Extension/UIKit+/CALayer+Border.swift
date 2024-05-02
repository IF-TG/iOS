//
//  CALayer+Border.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/26.
//

import Foundation
import UIKit.UIColor

/// 특정 view의 전체 부분에 borderWidth와 borderColor를 추가하는 것이 아니라,
/// 특정 부분에만 borderWidth와 borderColor를 적용하는 함수입니다.

/// UIView의 특정 위치에 borderStyle 적용
/// # Example #
///
/// view의 top, left부분에 border Style 적용
/// Example:
/// ```
/// let customView = UIView()
///
/// in VC, viewDidLayoutSubviews 시점
/// in View, layoutSubviews 시점
/// customView.layer.addBorder(at: [.top, .left], color: .black, width: 1)
/// ```
extension CALayer {
  func addBorder(at edges: [UIRectEdge], color: UIColor, width: CGFloat) {
    for edge in edges {
      let border = CALayer()
      switch edge {
      case UIRectEdge.top:
        border.frame = CGRect.init(x: 0, y: 0, width: self.frame.width, height: width)
      case UIRectEdge.bottom:
        border.frame = CGRect.init(x: 0, y: self.frame.height - width, width: self.frame.width, height: width)
      case UIRectEdge.left:
        border.frame = CGRect.init(x: 0, y: 0, width: width, height: self.frame.height)
      case UIRectEdge.right:
        border.frame = CGRect.init(x: self.frame.width - width, y: 0, width: width, height: self.frame.height)
      default: break
      }
      
      border.backgroundColor = color.cgColor
      self.addSublayer(border)
    }
  }
}
