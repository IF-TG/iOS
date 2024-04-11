//
//  BottomBasedTooltipView.swift
//  travelPlan
//
//  Created by 양승현 on 4/11/24.
//

import UIKit

class BottomBasedTooltipView: UIView {
  enum TipPosition {
    case left
    case right
    case middle
    case customStartX(CGFloat)
  }
  
  // MARK: - Properties
  private let toolTipSize: CGSize
  
  private let tipOffset: CGFloat
  
  private let tipPosition: TipPosition
  
  private let label: BasePaddingLabel
  
  private let cornerRadius: CGFloat
  
  private var defaultRect: CGRect!
  
  init(
    frame: CGRect,
    toolTipSize: CGSize = .init(width: 20, height: 14),
    tipOffset: CGFloat = 20,
    tipPosition: TipPosition = .middle,
    cornerRadius: CGFloat = 7,
    message: String,
    labelPadding: UIEdgeInsets,
    labelFontType: UIFont.Pretendard
  ) {
    self.toolTipSize = toolTipSize
    self.tipOffset = tipOffset
    self.tipPosition = tipPosition
    self.cornerRadius = cornerRadius
    self.label = BasePaddingLabel(
      frame: .zero,
      padding: labelPadding,
      fontType: labelFontType
    ).set {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.lineBreakMode = .byTruncatingTail
      $0.numberOfLines = 0
    }
    label.text = message
    super.init(frame: frame)
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    defaultRect = CGRect(
      x: rect.minX, y: rect.minY,
      width: rect.width, height: rect.height-toolTipSize.height)
    let roundRectBez = UIBezierPath(roundedRect: defaultRect, cornerRadius: cornerRadius)

  }
  
  required init?(coder: NSCoder) { nil }
}

// MARK: - Private Helpers
private extension BottomBasedTooltipView {
  func getStartX() -> CGFloat {
    switch tipPosition {
    case .left:
      return defaultRect.maxX/4-toolTipSize.width/2
    case .middle:
      return (defaultRect.maxX + toolTipSize.width)/2
    case .right:
      return defaultRect.maxX/4*3-toolTipSize.width/2
    case .customStartX(let startX):
      if startX + toolTipSize.width >= defaultRect.width {
        return defaultRect.maxX-toolTipSize.width-5
      }
      return startX
    }
  }
}
