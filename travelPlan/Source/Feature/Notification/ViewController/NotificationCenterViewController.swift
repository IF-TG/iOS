//
//  NotificationCenterViewController.swift
//  travelPlan
//
//  Created by 양승현 on 10/27/23.
//

import UIKit

final class NotificationCenterViewController: UIViewController {
  enum Constant {
    enum SegmentedControl {
      static let underbarInfo: UnderbarInfo = .init(height: 3, barColor: .yg.primary, backgroundColor: .yg.gray0)
      static let fontSize: CGFloat = 16
      static let fontColor: UIColor = .yg.gray1
      static let height: CGFloat = 47
    }
    
    enum NavigationBar {
      static let titleFont: UIFont = .init(pretendard: .semiBold, size: 18)!
      static let titleColor: UIColor = .yg.gray7
    }
  }
  
  // MARK: - Properties
  private let segmentedControl = RedAlarmBasedUnderbarSegmentedControl(
    items: ["알림", "공지사항"],
    underbarInfo: Constant.SegmentedControl.underbarInfo
  ).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
}

// MARK: - Helpers

// MARK: - Private Helpers
private extension NotificationCenterViewController {
  func configureUI() {
    setupUI()
    setSegmentedControl()
    setNavigationBar()
    view.backgroundColor = .white
    
  }
  
  func setSegmentedControl() {
    typealias Const = Constant.SegmentedControl
    let attributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: Const.fontColor,
        .font: UIFont(pretendard: .medium, size: Const.fontSize)!]
    segmentedControl.setTitleTextAttributes(attributes, for: .normal)
  }
  
  func setNavigationBar() {
    typealias Const = Constant.NavigationBar
    setupDefaultBackBarButtonItem()
    navigationController?.navigationBar.titleTextAttributes = [
      .foregroundColor: Const.titleColor,
      .font: Const.titleFont]
    navigationController?.navigationBar.topItem?.title = "알림센터"
  }
}

// MARK: - LayoutSupport
extension NotificationCenterViewController: LayoutSupport {
  func addSubviews() {
    _=[
      segmentedControl
    ].map { view.addSubview($0) }
  }
  
  func setConstraints() {
    _=[
      segmentedControlConstraints
    ].map {
      NSLayoutConstraint.activate($0)
    }
  }
}
// MARK: - LayoutSupport Constraints
extension NotificationCenterViewController {
  private var segmentedControlConstraints: [NSLayoutConstraint] {
    typealias Const = Constant.SegmentedControl
    return [
      segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      segmentedControl.heightAnchor.constraint(equalToConstant: Const.height)]
  }
}
