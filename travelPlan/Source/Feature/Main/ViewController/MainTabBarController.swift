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
    $0.backgroundColor = .white
  }
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor(hex: "F9F9F9")
    setupUI()
    configureTabBar()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
  }
}

extension MainTabBarController {
  // MARK: - Helpers
  private func configureTabBar() {
    configureTabBarAppearance()
    configureItems()
    configureShadow()
  }
  
  private func configureTabBarAppearance() {
    tabBar.backgroundColor = .white
  
    let appearance = UITabBarAppearance()
    appearance
      .stackedLayoutAppearance
      .selected
      .titleTextAttributes = [
        .foregroundColor: UIColor(hex: "6DB26B")
      ]
    
    self.tabBar.standardAppearance = appearance
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
  
  // RefactoringFIXME: - refactoring custom ShadowContainerView
  private func configureShadow() {
    let shadows = UIView()
    shadows.frame = shadowContainerView.frame
    shadows.clipsToBounds = false
    shadowContainerView.addSubview(shadows)

    let shadowPath0 = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: 0)
    let layer0 = CALayer()
    layer0.shadowPath = shadowPath0.cgPath
    layer0.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08).cgColor
    layer0.shadowOpacity = 1
    layer0.shadowRadius = 20
    layer0.shadowOffset = CGSize(width: 1, height: -10)
    layer0.bounds = shadows.bounds
    layer0.position = shadows.center
    shadows.layer.addSublayer(layer0)

    let shapes = UIView()
    shapes.frame = shadowContainerView.frame
    shapes.clipsToBounds = true
    shadowContainerView.addSubview(shapes)

    let layer1 = CALayer()
    layer1.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
    layer1.bounds = shapes.bounds
    layer1.position = shapes.center
    shapes.layer.addSublayer(layer1)
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
      $0.height.equalTo(60)
      $0.centerX.equalToSuperview()
      $0.bottom.equalToSuperview().inset(35)
    }
  }
}
