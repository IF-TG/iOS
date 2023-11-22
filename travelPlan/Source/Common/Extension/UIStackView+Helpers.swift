//
//  UIStackView+Helpers.swift
//  travelPlan
//
//  Created by 양승현 on 11/22/23.
//

import UIKit.UIStackView

extension UIStackView {
  func configureDefaultPostThumbnail(with axis: NSLayoutConstraint.Axis) {
    self.axis = axis
    spacing = 1
    distribution = .equalSpacing
    alignment = .fill
  }
}
