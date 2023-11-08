//
//  BasePaddingLabel.swift
//  travelPlan
//
//  Created by 양승현 on 10/11/23.
//

import UIKit

class BasePaddingLabel: BaseLabel {
  // MARK: - Properties
  private var padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
  
  // MARK: - Lifecycle
  init(
    frame: CGRect,
    padding: UIEdgeInsets,
    fontType: UIFont.Pretendard,
    lineHeight: CGFloat? = nil
  ) {
    self.padding = padding
    super.init(frame: frame, fontType: fontType, lineHeight: lineHeight)
  }
  
  convenience init(
    padding: UIEdgeInsets,
    fontType: UIFont.Pretendard,
    lineHeight: CGFloat? = nil
  ) {
    self.init(frame: .zero, padding: padding, fontType: fontType, lineHeight: lineHeight)
  }
  
  required init?(coder: NSCoder) {
    nil
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
