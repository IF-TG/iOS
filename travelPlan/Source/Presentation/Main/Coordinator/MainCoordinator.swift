//
//  MainCoordinator.swift
//  travelPlan
//
//  Created by 양승현 on 2023/06/30.
//

import UIKit
import SHCoordinator

protocol MainCoordinatorDependencies {
  func makeFeedCoordinator(
    presenter: UINavigationController
  ) -> FeedCoordinator
  
  func makeSearchCoordinator(
    presenter: UINavigationController
  ) -> SearchCoordinator
  
  func makePlanCoordinator(
    presenter: UINavigationController
  ) -> PlanCoordinator
  
  func makeFavoriteCoordinator(
    presenter: UINavigationController
  ) -> FavoriteCoordinator
  
  func makeSettingCoordinator(
    presenter: UINavigationController
  ) -> SettingCoordinator
}

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
  
  private(set) var tabBarController: MainTabBarController
  
  private var dependencies: MainCoordinatorDependencies
  
  // MARK: - Life cycle
  init(tabBarController: MainTabBarController, dependencies: MainCoordinatorDependencies) {
    self.tabBarController = tabBarController
    self.dependencies = dependencies
    tabBarController.coordinator = self
  }
  
  // MARK: - Helpers
  func start() {
    let feed = dependencies.makeFeedCoordinator(presenter: UINavigationController())
    let search = dependencies.makeSearchCoordinator(presenter: UINavigationController())
    let plan = dependencies.makePlanCoordinator(presenter: UINavigationController())
    let favorite = dependencies.makeFavoriteCoordinator(presenter: UINavigationController())
    let setting = dependencies.makeSettingCoordinator(presenter: UINavigationController())
    
    addChild(with: feed)
    addChild(with: search)
    addChild(with: plan)
    addChild(with: favorite)
    addChild(with: setting)
    
    tabBarController.viewControllers = child.compactMap { $0.presenter }
    tabBarController.setTabBarIcon()
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
    tabBarController.selectedIndex = 0
  }
}

// MARK: - Helpers for universal link
extension MainCoordinator {
  fileprivate var feedCoordinator: FeedCoordinator {
    if let index = child.firstIndex(where: { $0 is FeedCoordinator}),
       let feedCoordinator = child[index] as? FeedCoordinator {
      return feedCoordinator
    }
    /// 사실 이 시점에, Feed Coordinator는 MainCoordinator가 있다면 반드시 있어야 합니다!!
    let feed = dependencies.makeFeedCoordinator(presenter: UINavigationController())
    addChild(with: feed)
    return feed
  }
  /// universal link에 의해 포스트가 실행될 경우, 포스트 상세 화면으로 이동해야합니다.
  func showFeedDetail(with postId: PostIdentifier) {
    feedCoordinator.showPostDetailFromUniversalLink(with: postId)
  }
  
  func showAlertInFeed(title: String, message: String) {
    feedCoordinator.showAlert(withTitle: title, message: message)
  }
}
