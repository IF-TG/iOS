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
      static let dividerHeight: CGFloat = 1
    }
  }
  
  // MARK: - Properties
  private let segmentedControl = RedAlarmBasedUnderbarSegmentedControl(
    items: ["알림", "공지사항"],
    underbarInfo: Constant.SegmentedControl.underbarInfo)
  
  weak var coordinator: NotificationCenterCoordinatorDelegate?
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  deinit {
    coordinator?.finish()
    print("\(Self.self) deinit")
  }
}

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
    segmentedControl.translatesAutoresizingMaskIntoConstraints = false
    segmentedControl.addTarget(self, action: #selector(didTapSegmentedControl), for: .valueChanged)
  }
  
  func setNavigationBar() {
    typealias Const = Constant.NavigationBar
    setupDefaultBackBarButtonItem()
    let navigationTitleLabel = UILabel().set {
      $0.numberOfLines = 1
      $0.textAlignment = .center
      let title = "알림센터"
      let attrStr = NSMutableAttributedString(string: title)
      let attributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: Const.titleColor,
        .font: Const.titleFont]
      attrStr.addAttributes(attributes, range: NSRange(location: 0, length: title.count))
      $0.attributedText = attrStr
      $0.sizeToFit()
    }
    navigationItem.titleView = navigationTitleLabel
    let naviBarDivider = OneUnitHeightLine(color: .yg.gray0)
    view.addSubview(naviBarDivider)
    NSLayoutConstraint.activate([
      naviBarDivider.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      naviBarDivider.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      naviBarDivider.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -Const.dividerHeight),
      naviBarDivider.heightAnchor.constraint(equalToConstant: Const.dividerHeight)])
  }
}

// MARK: - Actions
extension NotificationCenterViewController {
  @objc func didTapSegmentedControl(_ sender: UISegmentedControl) {
    segmentedControl.selectedSegmentIndex = sender.selectedSegmentIndex
    // TODO: - 페이지 뷰 써서 페이지 전환
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
