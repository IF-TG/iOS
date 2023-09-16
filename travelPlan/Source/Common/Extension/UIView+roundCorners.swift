//
//  UIView+roundCorners.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/09/16.
//

import UIKit

extension UIView {

  /// 원하는 모서리의 cornerRadius를 지정하는 메서드입니다.
  /// ```
  /// // Example
  /// let customView = UIView()
  /// customView.roundCorners(cornerRadius: 10, cornerList: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
  /// ```
  func roundCorners(cornerRadius: CGFloat, cornerList: CACornerMask) {
    self.clipsToBounds = true
    self.layer.cornerRadius = cornerRadius
    self.layer.maskedCorners = CACornerMask(arrayLiteral: cornerList)
  }
}
