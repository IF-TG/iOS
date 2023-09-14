//
//  UIViewController.swift
//  travelPlan
//
//  Created by 양승현 on 2023/09/15.
//

import UIKit

extension UIViewController {
  func presentBottomSheet(_ viewController: UIViewController) {
    viewController.modalPresentationStyle = .overFullScreen
    present(viewController, animated: false)
  }
}
