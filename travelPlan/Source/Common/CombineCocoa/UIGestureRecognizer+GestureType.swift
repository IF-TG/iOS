//
//  UIGestureRecognizer+GestureType.swift
//  travelPlan
//
//  Created by 양승현 on 11/29/23.
//

import UIKit.UIGestureRecognizer

// MARK: - Nested
public extension UIGestureRecognizer {
  @frozen enum GestureType {
    case tap
    case swipe
    case edge
    case longPress
    case pan
    case pinch
    
    var `type`: UIGestureRecognizer {
      let dict = [
        .tap: UITapGestureRecognizer(),
        .swipe: UISwipeGestureRecognizer(),
        .edge: UIScreenEdgePanGestureRecognizer(),
        .longPress: UILongPressGestureRecognizer(),
        .pan: UIPanGestureRecognizer(),
        .pinch: UIPinchGestureRecognizer()
      ] as [GestureType: UIGestureRecognizer]
    }
  }
}
