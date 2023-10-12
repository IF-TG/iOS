//
//  BasePaddingLabel.swift
//  travelPlan
//
//  Created by 양승현 on 10/11/23.
//

import UIKit

class BasePaddingLabel: UILabel {
  // MARK: - Properties
  private var padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
  
  // MARK: - Lifecycle
  convenience init(padding: UIEdgeInsets) {
    self.init()
    self.padding = padding
  }
  
  override func drawText(in rect: CGRect) {
    super.drawText(in: rect.inset(by: padding))
  }
  
  override var intrinsicContentSize: CGSize {
    var contentSize = super.intrinsicContentSize
    contentSize.height += padding.top + padding.bottom
    contentSize.width += padding.left + padding.right
    return contentSize
  }
}
