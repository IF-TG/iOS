//
//  MainTabBarController.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/05.
//

import UIKit
import SnapKit

final class MainTabBarController: UITabBarController {
  // MARK: - Properties
  weak var coordinator: MainCoordinatorDelegate?
  private var viewControllerBuffer = [UIViewController]()

  private lazy var shadowContainerView: UIView = UIView().set {
    $0.frame = self.tabBar.bounds
    $0.backgroundColor = .clear
    $0.clipsToBounds = false
  }
  private lazy var shadowLayer: CALayer = CALayer().set {
    let shadowPath = UIBezierPath(roundedRect: shadowContainerView.bounds, cornerRadius: 0)
    $0.shadowPath = shadowPath.cgPath
    $0.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08).cgColor
    $0.shadowOpacity = 1
    $0.shadowRadius = 10
    $0.bounds = shadowContainerView.bounds
    $0.position = shadowContainerView.center
  }
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .yg.gray00Background
    setupUI()
    configureTabBar()
  }
  
  private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  convenience init() {
    self.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
}

// MARK: - Helpers
extension MainTabBarController {
  private func configureTabBar() {
    configureTabBarAppearance()
  }
  
  private func configureTabBarAppearance() {
    let appearance = UITabBarAppearance()
    appearance
      .stackedLayoutAppearance
      .selected
      .titleTextAttributes = [.foregroundColor: UIColor.yg.primary]

    self.tabBar.standardAppearance = appearance
    self.tabBar.backgroundColor = .white
  }
  
  func setTabBarIcon() {
    let tabBarList: [TabBarCase] = [.feed, .search, .plan, .favorite, .profile]
    let tabBarItems = tabBarList.map {
      let imageName = $0.rawValue
      let selectedImage = UIImage(named: imageName)?.withTintColor(UIColor.yg.primary, renderingMode: .alwaysOriginal)
      return UITabBarItem(title: $0.title, image: UIImage(named: imageName), selectedImage: selectedImage)
    }
    guard let viewControllers = viewControllers else { return }
    _=viewControllers.enumerated().map { $1.tabBarItem = tabBarItems[$0] }
  }
}

// MARK: - LayoutSupport
extension MainTabBarController: LayoutSupport {
  func addSubviews() {
    self.view.addSubview(shadowContainerView)
    shadowContainerView.layer.addSublayer(shadowLayer)
    self.view.bringSubviewToFront(self.tabBar)
  }
  
  func setConstraints() {
    shadowContainerView.snp.makeConstraints {
      $0.width.equalToSuperview()
      $0.height.equalTo(1)
      $0.centerX.equalToSuperview()
      $0.bottom.equalTo(self.tabBar.snp.top)
    }
  }
}
