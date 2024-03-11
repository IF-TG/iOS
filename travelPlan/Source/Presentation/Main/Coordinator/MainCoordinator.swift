//
//  MainCoordinator.swift
//  travelPlan
//
//  Created by 양승현 on 2023/06/30.
//

import UIKit
import SHCoordinator

protocol MainCoordinatorDelegate: AnyObject {
  func finish()
  func showLogin()
  func showFeed()
}

final class MainCoordinator: FlowCoordinator {
  // MARK: - Properties
  var parent: FlowCoordinator?
  var child: [FlowCoordinator] = []
  let presenter: UINavigationController? = nil
  let mainTabBarPresenter: MainTabBarController
  
  init(mainTabBarViewController: MainTabBarController) {
    self.mainTabBarPresenter = mainTabBarViewController
    mainTabBarPresenter.coordinator = self
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
    
    mainTabBarPresenter.viewControllers = child.compactMap { $0.presenter }
    mainTabBarPresenter.setTabBarIcon()
  }
}

// MARK: - MainCoordinatorDelegate
extension MainCoordinator: MainCoordinatorDelegate {
  func showLogin() {
    guard let parent = parent as? ApplicationCoordinator else {
      NSLog("DEBUG: Parent is not applicationCoordinator")
      return
    }
    parent.gotoLoginPage(withDelete: self)
  }
  
  func showFeed() {
    mainTabBarPresenter.selectedIndex = 0
  }
}
