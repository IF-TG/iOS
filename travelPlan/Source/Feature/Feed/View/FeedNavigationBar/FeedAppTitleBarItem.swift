//
//  FeedAppTitleBarItem.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/16.
//

import UIKit

final class FeedAppTitleBarItem: UIView {
  // MARK: - Properteis
  
  let appTitle = UILabel().set {
    let text = Constant.Title.text
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.textColor = Constant.Title.textColor
    $0.font = UIFont(
      name: Constant.Title.fontName,
      size: Constant.Title.fontSize)
    $0.numberOfLines = 0
    $0.textAlignment = .center
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineHeightMultiple = 1.02
    $0.attributedText = NSMutableAttributedString(
      string: text,
      attributes: [.kern: -0.41, .paragraphStyle: paragraphStyle])
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
    addSubview(appTitle)
  }
  
  func setConstraints() {
    NSLayoutConstraint.activate([
      appTitle.leadingAnchor.constraint(
        equalTo: leadingAnchor,
        constant: Constant.Spacing.leading),
      appTitle.topAnchor.constraint(
        equalTo: topAnchor,
        constant: Constant.Spacing.top),
      appTitle.trailingAnchor.constraint(
        equalTo: trailingAnchor,
        constant: -Constant.Spacing.trailing),
      appTitle.bottomAnchor.constraint(
        equalTo: bottomAnchor,
        constant: -Constant.Spacing.bottom)
    ])
  }
}
