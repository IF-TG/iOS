//
//  UIAlertController+.swift
//  travelPlan
//
//  Created by 양승현 on 6/9/24.
//

import UIKit

extension UIAlertController {
  func addAction(title: String, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)?) {
    self.addAction(UIAlertAction(title: title, style: style, handler: handler))
  }
}
