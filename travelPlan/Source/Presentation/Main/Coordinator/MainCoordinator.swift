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
    let profile = SettingCoordinator(presenter: UINavigationController())
    
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
  
  /// universal link에 의해 포스트가 실행될 경우, 포스트 상세 화면으로 이동해야합니다.
  func showFeedDetail(with postId: Int32?) {
    guard
      let index = child.firstIndex(where: { $0 is FeedCoordinator}),
      let feedCoordinator = child[index] as? FeedCoordinator
    else { return }
    feedCoordinator.showPostDetailFromUniversalLink(with: postId)
  }
}
