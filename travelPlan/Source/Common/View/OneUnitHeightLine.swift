//
//  OneUnitHeightLine.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/14.
//

import UIKit

final class OneUnitHeightLine: UIView {
  // MARK: - Constants
  private let height: CGFloat = 1
  
  // MARK: - Initialization
  fileprivate override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  convenience init(_ color: UIColor = .yg.gray0) {
    self.init(frame: .zero)
  }
}

//MARK: -  Constants
extension OneUnitHeightLine {
  struct Spacing {
    let leading: CGFloat
    let trailing: CGFloat
    let bottom: CGFloat
    let top: CGFloat
    init(leading: CGFloat = 0, trailing: CGFloat = 0, bottom: CGFloat = 0, top: CGFloat = 0) {
      self.leading = leading
      self.trailing = trailing
      self.bottom = bottom
      self.top = top
    }
  }
}

// MARK: - Helpers
extension OneUnitHeightLine {
  
  fileprivate func configureUI(_ color: UIColor) {
    translatesAutoresizingMaskIntoConstraints = false
    heightAnchor.constraint(
      equalToConstant: height).isActive = true
    backgroundColor = color
  }
  
  // superView만 필요한 경우
  func setConstraint(
    fromSuperView superView: UIView,
    spacing: Spacing
  ) {
    superView.addSubview(self)
    NSLayoutConstraint.activate([
      leadingAnchor.constraint(
        equalTo: superView.leadingAnchor,
        constant: spacing.leading),
      bottomAnchor.constraint(
        equalTo: superView.bottomAnchor,
        constant: -spacing.bottom),
      trailingAnchor.constraint(
        equalTo: superView.trailingAnchor,
        constant: -spacing.trailing)
    ])
  }
  // superView랑 line 위에 view가 있는 경우
  func setConstraint(
    fromTopView topView: UIView,
    superView: UIView,
    spacing: Spacing
  ) {
    topAnchor.constraint(
      equalTo: topView.bottomAnchor,
      constant: spacing.top).isActive = true
    setConstraint(fromSuperView: superView, spacing: spacing)
  }
  
}
