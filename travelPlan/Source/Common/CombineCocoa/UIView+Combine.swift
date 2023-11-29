//
//  UIView+Combine.swift
//  travelPlan
//
//  Created by 양승현 on 11/29/23.
//

import UIKit.UIView
import UIKit.UIGestureRecognizer

@available(iOS 13.0, *)
extension UIView {
  /// A publihser emitting events.
  func publihser(
    for gesture: UIGestureRecognizer.GestureType
  ) -> UIGestureRecognizer.Publisher<UIGestureRecognizer> {
    return UIGestureRecognizer.Publisher(view: self, gestureRecognizer: gesture.type)
  }
}
