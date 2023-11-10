//
//  UIViewController.swift
//  travelPlan
//
//  Created by 양승현 on 2023/09/15.
//

import UIKit

// MARK: - Presentation
extension UIViewController {
  func presentBottomSheet(_ viewController: UIViewController, _ completion: (() -> Void)? = nil) {
    viewController.modalPresentationStyle = .overFullScreen
    present(viewController, animated: false, completion: completion)
  }
}

// MARK: - Animation
extension UIViewController {
  func setTabBarVisible(_ hidden: Bool, animated: Bool = true, duration: TimeInterval = 0.27) {
    if animated, var frame = tabBarController?.tabBar.frame {
      frame.origin.y = CGFloat(hidden.toInt) * frame.size.height
      UIView.animate(withDuration: duration, animations: {
        self.tabBarController?.tabBar.frame = frame
      }, completion: { _ in
        self.tabBarController?.tabBar.isHidden = hidden
      })
      return
    }
    self.tabBarController?.tabBar.isHidden = hidden
  }
}
