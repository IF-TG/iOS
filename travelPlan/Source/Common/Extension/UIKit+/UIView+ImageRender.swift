//
//  UIView+ImageRender.swift
//  travelPlan
//
//  Created by 양승현 on 5/28/24.
//

import UIKit

public extension UIView {
  /// Redner UIImage from UIView
  /// UIView를 이미지로 변환합니다.
  ///
  /// - Parameters size: 주어진 크기 기반으로 UIImage로 render합니다. nil인 경우 현제 뷰가 갖고 있는 크기를 바탕으로 이미지로 변환합니다.
  func image(withSize size: CGSize? = nil) -> UIImage {
    var _size: CGSize = size ?? self.layer.bounds.size
    return UIGraphicsImageRenderer(size: _size).image { context in
      self.layer.render(in: context.cgContext)
    }
  }
}
