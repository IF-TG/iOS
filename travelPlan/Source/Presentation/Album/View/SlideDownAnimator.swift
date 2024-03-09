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
    guard let fromView = transitionContext.view(forKey: .from),
    let toView = transitionContext.view(forKey: .to) else { return }
    
    let containerView = transitionContext.containerView
    containerView.insertSubview(toView, belowSubview: fromView)
    
    UIView.animate(
      withDuration: transitionDuration(using: transitionContext),
      animations: {
        fromView.transform = .identity
      }) { completed in
        transitionContext.completeTransition(completed)
      }
  }
}
