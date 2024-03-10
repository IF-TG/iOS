//
//  UIViewController+Indicator.swift
//  travelPlan
//
//  Created by 양승현 on 3/11/24.
//

import UIKit

extension UIViewController {
  private static var activityIndicatorTag: Int { return 999 }
  private static var overlayViewTag: Int { return 998 }
  
  func startIndicator() {
    let indicator = UIActivityIndicatorView(style: .large)
    indicator.center = view.center
    indicator.tag = UIViewController.activityIndicatorTag
    view.addSubview(indicator)
    indicator.startAnimating()
    
    let overlayView = UIView(frame: view.bounds)
    overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    overlayView.tag = UIViewController.overlayViewTag
    view.addSubview(overlayView)
  }
  
  func stopIndicator() {
    if let indicator = view.subviews
      .filter({ $0.tag == UIViewController.activityIndicatorTag }).first as? UIActivityIndicatorView {
      indicator.stopAnimating()
      indicator.removeFromSuperview()
    }
    if let overlayView = view.subviews.filter({ $0.tag == UIViewController.overlayViewTag }).first {
      overlayView.removeFromSuperview()
    }
  }
}
