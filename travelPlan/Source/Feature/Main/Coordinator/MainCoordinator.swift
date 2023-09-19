//
//  MainCoordinator.swift
//  travelPlan
//
//  Created by 양승현 on 2023/06/30.
//

import UIKit
import SHCoordinator

final class MainCoordinator: FlowCoordinator {
  // MARK: - Properties
  var parent: FlowCoordinator!
  var child: [FlowCoordinator] = []
  let presenter: UINavigationController! = nil
  let mainTabBarPresenter: MainTabBarController
  var viewController: UIViewController!
  
  init(mainTabBarViewController: MainTabBarController) {
    self.mainTabBarPresenter = mainTabBarViewController
  }
  // MARK: - Helpers
  func start() {
    let feed = FeedCoordinator(presenter: UINavigationController())
    let search = SearchCoordinator(presenter: UINavigationController())
    let plan = PlanCoordinator(presenter: UINavigationController())
    let favorite = FavoriteCoordinator(presenter: UINavigationController())
    let profile = ProfileCoordinator(presenter: UINavigationController())
    
    addChild(with: feed)
    addChild(with: search)
    addChild(with: plan)
    addChild(with: favorite)
    addChild(with: profile)
    
    mainTabBarPresenter.viewControllers = child.map { $0.presenter }
    mainTabBarPresenter.setTabBarIcon()
  }
}

// MARK: - Setup other Coordinator
extension MainCoordinator {
  func gotoLoginPage() {
    guard let parent = parent as? ApplicationCoordinator else {
      NSLog("DEBUG: Parent is not applicationCoordinator")
      return
    }
    parent.gotoLoginPage(withDelete: self)
  }
  
  func gotoFeedPage() {
    mainTabBarPresenter.selectedIndex = 0
  }
}
