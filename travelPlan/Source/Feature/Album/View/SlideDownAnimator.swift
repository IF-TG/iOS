//
//  SlideDownAnimator.swift
//  travelPlan
//
//  Created by SeokHyun on 1/13/24.
//

import UIKit

class SlideDownAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.5
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let fromView = transitionContext.view(forKey: .from) else { return }
    UIView.animate(
      withDuration: 0.5,
      animations: {
        fromView.transform = .identity
      }) { completed in
        transitionContext.completeTransition(completed)
      }
  }
}
