//
//  UIControl+Combine.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/01.
//

import UIKit
import Combine

@available(iOS 13.0, *)
extension UIControl {
  /// A publisher emitting events.
  func publisher(
    for event: UIControl.Event
  ) -> UIControl.InteractionPublihser {
    return InteractionPublihser(control: self, event: event)
  }
}
