//
//  UIViewController+Indicator.swift
//  travelPlan
//
//  Created by 양승현 on 3/11/24.
//

import UIKit

class DefaultActivityIndicatorView: UIActivityIndicatorView {
  
  private let backgroundLayer = CALayer()
  
  override init(style: UIActivityIndicatorView.Style) {
    super.init(style: style)
    setBackgroundLayer()
  }
  
  required init(coder: NSCoder) {
    super.init(coder: coder)
    setBackgroundLayer()
  }
  
  private func setBackgroundLayer() {
    backgroundLayer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
    backgroundLayer.cornerRadius = 10
    layer.insertSublayer(backgroundLayer, at: 0)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    let centerX = bounds.midX
    let centerY = bounds.midY
    let width = bounds.width * 2.1
    let height = bounds.height * 2.1
    let x = centerX - width / 2
    let y = centerY - height / 2
    backgroundLayer.frame = CGRect(x: x, y: y, width: width, height: height)
  }
}

extension UIViewController {
  var activeIndicator: UIActivityIndicatorView? {
    view.subviews
      .filter { $0 is DefaultActivityIndicatorView }
      .compactMap { $0 as? UIActivityIndicatorView }
      .first
  }
  
  func startIndicator() {
    guard activeIndicator == nil else { return }
    let indicator = DefaultActivityIndicatorView(style: .large)
    indicator.center = view.center
    view.addSubview(indicator)
    view.bringSubviewToFront(indicator)
    indicator.startAnimating()
  }
  
  func stopIndicator() {
    activeIndicator?.stopAnimating()
    activeIndicator?.removeFromSuperview()
  }
}
