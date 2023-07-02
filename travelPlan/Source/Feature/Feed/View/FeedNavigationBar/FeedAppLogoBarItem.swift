//
//  FeedAppTitleBarItem.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/16.
//

import UIKit

final class FeedAppTitleBarItem: UIView {
  // MARK: - Properteis
  let appLogo = UIImageView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.image = UIImage(named: Constant.Image.text)
  }
  
  // MARK: - Initialization
  private override init(frame: CGRect) {
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  convenience init() {
    self.init(frame: .zero)
  }
}

// MARK: - LayoutSupport
extension FeedAppTitleBarItem: LayoutSupport {
  func addSubviews() {
    addSubview(appLogo)
  }
  
  func setConstraints() {
    NSLayoutConstraint.activate([
      appLogo.leadingAnchor.constraint(
        equalTo: leadingAnchor,
        constant: Constant.Spacing.leading),
      appLogo.topAnchor.constraint(
        equalTo: topAnchor,
        constant: Constant.Spacing.top),
      appLogo.trailingAnchor.constraint(
        equalTo: trailingAnchor,
        constant: -Constant.Spacing.trailing),
      appLogo.bottomAnchor.constraint(
        equalTo: bottomAnchor,
        constant: -Constant.Spacing.bottom)
    ])
  }
}
