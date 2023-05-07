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
  private var viewControllerBuffer = [UIViewController]()

  private lazy var shadowContainerView: UIView = UIView().set {
    $0.frame = self.tabBar.bounds
    $0.backgroundColor = .clear
    $0.clipsToBounds = false
  }
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor(hex: "F9F9F9")
    setupUI()
    configureTabBar()
  }
}

extension MainTabBarController {
  // MARK: - Helpers
  private func configureTabBar() {
    configureTabBarAppearance()
    configureItems()
    configureTabBarShadow()
  }
  
  private func configureTabBarAppearance() {
    let appearance = UITabBarAppearance()
    appearance
      .stackedLayoutAppearance
      .selected
      .titleTextAttributes = [.foregroundColor: UIColor(hex: "6DB26B")]

    self.tabBar.standardAppearance = appearance
    self.tabBar.backgroundColor = .white
  }
  
  private func configureItems() {
    let tabBarList: [TabBarCase] = [.feed, .search, .plan, .heart, .profile]
    _ = tabBarList.map { makeTabBarItem(type: $0)}
    
    self.viewControllers = viewControllerBuffer
  }
  
  private func makeTabBarItem(type: TabBarCase) {
    let navigationController: UINavigationController!
    
    let imageName = type.rawValue
    let selectedImage = UIImage(named: imageName)?.withTintColor(UIColor(hex: "6DB26B"), renderingMode: .alwaysOriginal)
    let tabBarItem = UITabBarItem(title: type.title, image: UIImage(named: imageName), selectedImage: selectedImage)
    
    switch type {
    case .feed:
      navigationController = UINavigationController(
        rootViewController: FeedViewController().set { $0.tabBarItem = tabBarItem })
    case .search:
      navigationController = UINavigationController(
        rootViewController: SearchViewController().set { $0.tabBarItem = tabBarItem })
    case .plan:
      navigationController = UINavigationController(
        rootViewController: PlanViewController().set { $0.tabBarItem = tabBarItem })
    case .heart:
      navigationController = UINavigationController(
        rootViewController: MarkViewController().set { $0.tabBarItem = tabBarItem })
    case .profile:
      navigationController = UINavigationController(
        rootViewController: ProfileViewController().set { $0.tabBarItem = tabBarItem })
    }
    viewControllerBuffer.append(navigationController)
  }
  
  private func configureTabBarShadow() {
    let shadowPath = UIBezierPath(roundedRect: shadowContainerView.bounds, cornerRadius: 0)
    let shadowLayer = CALayer()
    shadowLayer.shadowPath = shadowPath.cgPath
    shadowLayer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08).cgColor
    shadowLayer.shadowOpacity = 1
    shadowLayer.shadowRadius = 10
    shadowLayer.bounds = shadowContainerView.bounds
    shadowLayer.position = shadowContainerView.center
    shadowContainerView.layer.addSublayer(shadowLayer)
  }
}

extension MainTabBarController: LayoutSupport {
  func addSubviews() {
    self.view.addSubview(shadowContainerView)
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
