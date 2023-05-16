//
//  FeedPostSearchBarItem.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/16.
//

import UIKit

final class FeedPostSearchBarItem: UIButton {
  // MARK: - Properties
  
  var delegate: FeedNavigationBarDelegate?
  
  private override init(frame: CGRect) {
    super.init(frame: .zero)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Helpers

extension FeedPostSearchBarItem {
  func configureUI() {
    translatesAutoresizingMaskIntoConstraints = false
    let image = Constant.image
    setImage(
      image?.setColor(Constant.normalColor),
      for: .normal)
    setImage(
      image?.setColor(Constant.highlightColor),
      for: .highlighted)
    addTarget(self, action: #selector(didTapPostSearch), for: .touchUpInside)
    contentEdgeInsets = UIEdgeInsets(
      top: Constant.Inset.top,
      left: Constant.Inset.leading,
      bottom: Constant.Inset.bottom,
      right: Constant.Inset.trailing)
  }
}
