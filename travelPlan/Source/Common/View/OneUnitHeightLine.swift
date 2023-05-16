//
//  OneUnitHeightLine.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/14.
//

import UIKit

/// YG app에서 사용되는 얇은 그래이색 height 1 라인
/// # Example #
/// ```
/// Example:
/// class ViewController: UIViewController {
///   let content = UIView()
///   let line = OneUnitHeightLine(color: .yg.gray4)
///   viewDidAppear() {
///     setupUI()
///     line.setConstraint(fromSuperView: view)
///         //or spacing을 지정해야 할 경우
///         //line.setConstraint(
///             fromSuperView: view,
///             spacing: .init(leading: 20, trailing: 20))
/// 상위 뷰가 있을 때 상위뷰가 view.bottom과 연결되야 한다면 사이에 lien을 두는 함수
///         //line.setConstraint(
///             fromTopView: view,
///             superView: content,
///             spacing: ...)
/// }
final class OneUnitHeightLine: UIView {
  // MARK: - Constants
  private let height: CGFloat = 1
  
  // MARK: - Initialization
  fileprivate override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  convenience init(color: UIColor) {
    self.init(frame: .zero)
    backgroundColor = color
  }
}

// MARK: - Constants
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
  
  // superView만 필요한 경우
  func setConstraint(
    fromSuperView superView: UIView,
    spacing: Spacing
  ) {
    superView.addSubview(self)
    NSLayoutConstraint.activate([
      heightAnchor.constraint(equalToConstant: height),
      leadingAnchor.constraint(
        equalTo: superView.leadingAnchor,
        constant: spacing.leading),
      bottomAnchor.constraint(
        equalTo: superView.bottomAnchor,
        constant: -spacing.bottom),
      trailingAnchor.constraint(
        equalTo: superView.trailingAnchor,
        constant: -spacing.trailing)])
    superView.bringSubviewToFront(self)
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
