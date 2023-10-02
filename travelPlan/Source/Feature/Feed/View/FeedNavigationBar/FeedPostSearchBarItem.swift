//
//  FeedPostSearchBarItem.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/16.
//

import UIKit

final class FeedPostSearchBarItem: UIButton {  
  enum Constant {
    static let backgroundColor: UIColor = .white
    static let image = UIImage(named: "search")
    static let size = CGSize(width: 24, height: 24)
    
    enum Spacing {
      static let top: CGFloat = 5
      static let bottom: CGFloat = 5
      static let leading: CGFloat = 0
      static let trailing: CGFloat = 0
    }
    static let normalColor: UIColor = .yg.gray5
    static let highlightColor: UIColor = .yg.gray5.withAlphaComponent(0.5)
  }
  
  // MARK: - Initialization
  private override init(frame: CGRect) {
    super.init(frame: .zero)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  convenience init() {
    self.init(frame: .zero)
  }
}

// MARK: - Helpers
private extension FeedPostSearchBarItem {
  func configureUI() {
    translatesAutoresizingMaskIntoConstraints = false
    let image = Constant.image
    setImage(
      image?.setColor(Constant.normalColor),
      for: .normal)
    setImage(
      image?.setColor(Constant.highlightColor),
      for: .highlighted)

    contentEdgeInsets = UIEdgeInsets(
      top: Constant.Spacing.top,
      left: Constant.Spacing.leading,
      bottom: Constant.Spacing.bottom,
      right: Constant.Spacing.trailing)
  }
}
