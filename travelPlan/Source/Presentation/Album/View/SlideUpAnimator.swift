//
//  SlideUpAnimator.swift
//  travelPlan
//
//  Created by SeokHyun on 1/13/24.
//

import UIKit
import SnapKit

class SlideUpAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.5
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let toView = transitionContext.view(forKey: .to) else { return }
    let containerView = transitionContext.containerView
    containerView.addSubview(toView)
    containerView.bringSubviewToFront(toView)

    toView.transform = .init(translationX: 0, y: containerView.frame.height)
    
    UIView.animate(
      withDuration: transitionDuration(using: transitionContext),
      animations: {
        toView.transform = .identity
      }) { completed in
        transitionContext.completeTransition(completed)
      }
  }
}
