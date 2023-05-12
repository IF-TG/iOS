//
//  UIView+CustomAnimation.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/13.
//

import UIKit

/// UIView 터치했을 때 작 -> 원 효과 구현했습니다.
/// 레이블의 highlight를 설정하고 싶었는데 레이블은 안된다고 해서 구현했습니다.
extension UIView {
  static func touchAnimate(_ target: UIView, duration: CGFloat = 0.12) {
    animate(
      withDuration: duration,
      delay: 0,
      options: .curveEaseIn,
      animations: {
        target.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
      }) { _ in
        animate(
          withDuration: duration,
          delay: 0,
          options: .curveEaseOut,
          animations: {
            target.transform = .identity
          })
      }
  }
}
