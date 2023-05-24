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
///
///     높이를 지정해야 하는 경우
///     line.setHeight(0.4)
/// }
/// ```
///
final class OneUnitHeightLine: UIView {
  // MARK: - Constants
  private var height: CGFloat = 1
  private static let spacingFromNavigationBar: CGFloat = 5
  private lazy var heightConstraint = heightAnchor.constraint(equalToConstant: height)
  
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

// MARK: - Helpers
extension OneUnitHeightLine {
  
  /// 오토 레이아웃으로 SuperView만 필요한 경우.
  /// 이 경우는 cell이나 일반적인 커스텀 뷰의 bottom edge 경계선으로 다는 경우
  /// 일반적인 VC의 bottomAnchor에 달 경우 이 함수 사용해서는 안됩니다.
  /// BottomAnchor가 safeAreaLayoutGuide로 오토 레이아웃 미지정.
  func setConstraint(
    fromSuperView superView: UIView,
    spacing: UIConstantSpacing = .init(leading: 0, top: 0, trailing: 0, bottom: 0)
  ) {
    superView.addSubview(self)
    NSLayoutConstraint.activate([
      heightConstraint,
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
  
  /// 커스텀 UIView로 구현된 superView랑 line의 top view의 아래로 layout잡아야 하는 경우
  func setConstraint(
    fromTopView topView: UIView,
    superView: UIView,
    spacing: UIConstantSpacing = .init(leading: 0, top: 0, trailing: 0, bottom: 0)
  ) {
    topAnchor.constraint(
      equalTo: topView.bottomAnchor,
      constant: spacing.top).isActive = true
    setConstraint(fromSuperView: superView, spacing: spacing)
  }
  
  /// navigationBar의 아래 구분선으로 추가할 경우 직접 네비바에 subview로 하지 않습니다. (naviBar height가 인식하기 어려움)
  /// 그래서 ViewController의 view에 safeAreaLayoutGuide의 bottom 에 constraint 추가!!!!
  /// 그리고 viewController의 top은 viewController.view의 safeAreaLayoutGuide.topAnchor가 아닌, 이 인스턴스의 bottom으로 레이아웃을 잡아야 합니다.
  func setConstraintWhenNavigationBarBottomEdge(
    _ superView: UIView,
    spacing: UIConstantSpacing = .init(bottom: spacingFromNavigationBar)
  ) {
    superView.addSubview(self)
    NSLayoutConstraint.activate([
      topAnchor.constraint(
        equalTo: superView.safeAreaLayoutGuide.topAnchor,
        constant: spacing.bottom),
      leadingAnchor.constraint(
        equalTo: superView.leadingAnchor,
        constant: spacing.leading),
      trailingAnchor.constraint(
        equalTo: superView.trailingAnchor,
        constant: spacing.trailing),
      heightConstraint])
  }
  
  /// gray line의 높이를 바꾸고 싶은 경우
  func setHeight(_ height: CGFloat) {
    self.height = height
    heightConstraint.isActive = false
    heightConstraint = heightAnchor.constraint(equalToConstant: height)
    heightConstraint.isActive = true
  }
}
