//
//  UIStackView+Helpers.swift
//  travelPlan
//
//  Created by 양승현 on 11/22/23.
//

import UIKit.UIStackView

extension UIStackView {
  /// Feed 탭의 PostCell에 thumbnail이미지를 arranged subview로하는 stackview의 스택 뷰 공통 설정 값입니다.
  func configureDefaultPostThumbnail(with axis: NSLayoutConstraint.Axis) {
    self.axis = axis
    spacing = 1
    distribution = .fillEqually
  }
}
