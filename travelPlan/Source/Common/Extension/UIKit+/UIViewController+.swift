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
  
  func updateTabBarVisibility(_ visible: Bool) {
    if visible {
      tabBarController?.tabBar.isHidden = false
      (tabBarController as? MainTabBarController)?.showShadowLayer()
    } else {
      tabBarController?.tabBar.isHidden = true
      (tabBarController as? MainTabBarController)?.hideShadowLayer()
    }
  }
}
