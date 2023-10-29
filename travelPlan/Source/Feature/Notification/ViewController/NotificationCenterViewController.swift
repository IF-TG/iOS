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
  private let segmentedControl = RedIconBasedUnderbarSegmentedControl(
    items: ["알림", "공지사항"],
    underbarInfo: Constant.SegmentedControl.underbarInfo)
  
  private let viewControllers: [UIViewController]
  
  private lazy var pageViewController = UIPageViewController(
    transitionStyle: .scroll,
    navigationOrientation: .horizontal
  ).set {
    $0.view.translatesAutoresizingMaskIntoConstraints = false
    $0.setViewControllers(
      [viewControllers[0]],
      direction: .forward,
      animated: true)
  }
  
  private var pageView: UIView! {
    pageViewController.view
  }
  
  weak var coordinator: NotificationCenterCoordinatorDelegate?
  
  // MARK: - Lifecycle
  init(noticeViewModel: any NoticeViewModelable & NoticeViewAdapterDataSource) {
    viewControllers = [
      NotificationViewController(),
      NoticeViewController(viewModel: noticeViewModel)]
    super.init()
  }
  
  required init?(coder: NSCoder) {
    nil
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setTabBarVisible(false)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    setTabBarVisible(true)
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
    setNavigationTitle()
    setNavigationDivider()
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
  
  func setNavigationTitle() {
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
  }
  
  func setNavigationDivider() {
    typealias Const = Constant.NavigationBar
    let naviBarDivider = OneUnitHeightLine(color: .yg.gray0)
    view.addSubview(naviBarDivider)
    NSLayoutConstraint.activate([
      naviBarDivider.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      naviBarDivider.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      naviBarDivider.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -Const.dividerHeight),
      naviBarDivider.heightAnchor.constraint(equalToConstant: Const.dividerHeight)])
  }
  
  func setTabBarVisible(_ showTabBar: Bool) {
    let zPos = showTabBar ? 0 : -1
    guard let mainTabBarController = tabBarController as? MainTabBarController else { return }
    if showTabBar {
      mainTabBarController.showShadowLayer()
    } else {
      mainTabBarController.hideShadowLayer()
    }
    mainTabBarController.tabBar.layer.zPosition = CGFloat(zPos)
  }
}

// MARK: - Actions
extension NotificationCenterViewController {
  @objc func didTapSegmentedControl(_ sender: UISegmentedControl) {
    let selectedIndex = sender.selectedSegmentIndex
    segmentedControl.selectedSegmentIndex = selectedIndex
    let direction: UIPageViewController.NavigationDirection = selectedIndex == 0 ? .reverse : .forward
    pageViewController.setViewControllers(
      [viewControllers[sender.selectedSegmentIndex]],
      direction: direction,
      animated: true)
  }
}

// MARK: - LayoutSupport
extension NotificationCenterViewController: LayoutSupport {
  func addSubviews() {
    _=[
      segmentedControl,
      pageView
    ].map { view.addSubview($0) }
  }
  
  func setConstraints() {
    _=[
      segmentedControlConstraints,
      pageViewConstraints
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
  
  private var pageViewConstraints: [NSLayoutConstraint] {
    return [
      pageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      pageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      pageView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
      pageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
  }
}
