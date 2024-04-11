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
  
  private let colorInfo: ShadowInfo
  
  // MARK: - Lifecycle
  init(
    frame: CGRect,
    toolTipSize: CGSize = .init(width: 20, height: 14),
    tipOffset: CGFloat = 20,
    tipPosition: TipPosition = .middle,
    cornerRadius: CGFloat = 7,
    colorInfo: ShadowInfo,
    message: String,
    labelPadding: UIEdgeInsets = .init(top: 7, left: 7, bottom: 7, right: 7),
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
    self.colorInfo = colorInfo
    super.init(frame: frame)
    setupUI()
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    drawTooltip(rect)
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
  
  func drawTooltip(_ rect: CGRect) {
    defaultRect = CGRect(
      x: rect.minX, y: rect.minY,
      width: rect.width,
      height: rect.height-toolTipSize.height)
    let contentRectPath = UIBezierPath(roundedRect: defaultRect, cornerRadius: cornerRadius)
    let trianglePath = makeTipPath()
    contentRectPath.append(trianglePath)
    layer.insertSublayer(makeShapeLayer(contentRectPath.cgPath), at: 0)
  }
  
  func makeTipPath() -> UIBezierPath {
    let tooltipRect = CGRect(
      origin: .init(x: getStartX(), y: defaultRect.maxY),
      size: toolTipSize)
    return UIBezierPath().set {
      $0.move(to: CGPoint(x: tooltipRect.minX, y: tooltipRect.minY))
      $0.addLine(to: CGPoint(x: tooltipRect.midX, y: tooltipRect.maxY))
      $0.addLine(to: CGPoint(x: tooltipRect.maxX, y: tooltipRect.minY))
      $0.addLine(to: CGPoint(x: tooltipRect.minX, y: tooltipRect.minY))
      $0.close()
    }
  }
  
  func makeShapeLayer(_ path: CGPath) -> CAShapeLayer {
    return CAShapeLayer().set {
      $0.path = path
      $0.fillColor = colorInfo.color.cgColor
      $0.shadowColor = colorInfo.color.withAlphaComponent(0.4).cgColor
      $0.shadowOffset = CGSize(width: 0, height: 2)
      $0.shadowRadius = 7
      $0.shadowOpacity = 0.7
    }
  }
}

// MARK: - LayoutSupport
extension BottomBasedTooltipView: LayoutSupport {
  func addSubviews() {
    addSubview(label)
  }
  
  func setConstraints() {
    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: leadingAnchor),
      label.topAnchor.constraint(equalTo: topAnchor),
      label.trailingAnchor.constraint(equalTo: trailingAnchor),
      label.bottomAnchor.constraint(equalTo: bottomAnchor)])
  }
}
