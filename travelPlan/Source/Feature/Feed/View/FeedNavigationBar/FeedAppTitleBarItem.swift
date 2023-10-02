//
//  FeedAppTitleBarItem.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/16.
//

import UIKit

final class FeedAppTitleBarItem: UIView {
  enum Constant {
    static let backgroundColor: UIColor = .white
    static let size = CGSize(width: 24, height: 24)
    
    enum Image {
      static let text = "appLogo"
    }
    
    enum Spacing {
      static let top: CGFloat = 10
      static let bottom: CGFloat = 0
      static let leading: CGFloat = 15
      static let trailing: CGFloat = 0
    }
  }

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
    typealias Spacing = Constant.Spacing
    NSLayoutConstraint.activate([
      appLogo.leadingAnchor.constraint(
        equalTo: leadingAnchor,
        constant: Spacing.leading),
      appLogo.topAnchor.constraint(
        equalTo: topAnchor,
        constant: Spacing.top),
      appLogo.trailingAnchor.constraint(
        equalTo: trailingAnchor,
        constant: -Spacing.trailing),
      appLogo.bottomAnchor.constraint(
        equalTo: bottomAnchor,
        constant: -Spacing.bottom)
    ])
  }
}
