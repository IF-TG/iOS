//
//  FlowCoordinatorAssembly.swift
//  travelPlan
//
//  Created by 양승현 on 6/5/24.
//

import UIKit
import Swinject

/// Coordinator flow를 assmelby하는 객체입니다.
///
/// Notes :
/// 1. Coordinator는 mock, stub을 사용하지 않음으로, protocol을 통해 등록하지 않고 구현체를 등록하는게 수월합니다.
/// 2. Append the necessary dependencies property for  each own coordinators.
///    각각의 코디네이터에서 의존성 주입을 할떄 AppDIContainer를 사용할 수 있지만, protocol로 제약을 걸어 자신이 사용할 의존성을 직접 AppDIContainer에서 resolve로
///    dependency를 해결하도록 제약해야 합니다.
///
/// Examples notes no. 1:
/// ```
/// func assemble(container: Swinject.Container) {
///   /// 구현체가 하나이기 때문에 프로토콜로 등록하면 name관리가 힘듭니다.
///   /// container.register(FlowCoordinator.self, name: "FeedCoordinator") { _ in ... }
///
///   /// 이와 같이 구현체를 등록하면 수월합니다.
///   /// 유일한 구현체이므로 container에 register할 때 name을 붙이지 않습니다.
///   container.register(FeedCoordinator.self) { _ in ... }
/// }
/// ```
final class FlowCoordinatorAssembly: Assembly {
  func assemble(container: Swinject.Container) {
    let appDIContainer = AppDIContainer.shared
    
    searchResultListCoordinator(container: container)
    searchCoordinator(container: container)
    searchHistoryCoordinator(container: container)
    
    // TODO: - Login Flow Coordinator
    container.register(LoginCoordinator.self) { _ in
      return LoginCoordinator(presenter: nil, dependencies: appDIContainer)
    }
    
    // MARK: - PostDetail Flow Coordinator
    container.register(
      PostDetailCoordinator.self
    ) { (_, presenter: UINavigationController?, post: Post?, postId: PostIdentifier) in
      return PostDetailCoordinator(presenter: presenter, post: post, postId: postId, dependencies: appDIContainer)
    }
    
    // MARK: - Notification Flow Coordinator
    container.register(NotificationCenterCoordinator.self) { (_, presenter: UINavigationController?) in
      return NotificationCenterCoordinator(presenter: presenter, dependencies: appDIContainer)
    }
    
    // TODO: - Album Coordinator
    
    // MARK: - Main Flow Coordinator
    container.register(MainCoordinator.self) { r in
      let tabBarController = r.resolve(MainTabBarController.self)!
      return MainCoordinator(tabBarController: tabBarController, dependencies: appDIContainer)
    }
    
    // FIXME: - Setting Flow Coordinator.
    container.register(SettingCoordinator.self) { (_, presenter: UINavigationController) in
      SettingCoordinator(presenter: presenter)
    }
    
    // FIXME: - Favorite Flow Coordinator
    container.register(FavoriteCoordinator.self) { (_, presenter: UINavigationController) in
      FavoriteCoordinator(presenter: presenter)
    }
    
    // TODO: - SearchDetail Flow Coordinator
    
    // FIXME: - Plan Flow Coordinator
    container.register(PlanCoordinator.self) { (_, presenter: UINavigationController) in
      PlanCoordinator(presenter: presenter)
    }
    
    // TODO: - ReviewWriting Flow Coordinator
    
    // MARK: - Feed Flow Coordinator
    container.register(FeedCoordinator.self) { (_, presenter: UINavigationController) in
      FeedCoordinator(presenter: presenter, dependencies: appDIContainer)
    }
  }
}

// MARK: - Private Helpers
private extension FlowCoordinatorAssembly {
  func searchMoreDetailCoordinator(container: Container) {
    container.register(SearchMoreDetailCoordinator.self) {
      (_, presenter: UINavigationController?, viewControllerType: SearchSectionType) in
      return SearchMoreDetailCoordinator(presenter: presenter, viewControllerType: viewControllerType)
    }
  }
  
  func searchCoordinator(container: Container) {
    container.register(SearchCoordinator.self) { (_, presenter: UINavigationController?) in
      return SearchCoordinator(presenter: presenter)
    }
  }
  
  func searchResultListCoordinator(container: Container) {
    container.register(SearchResultListCoordinator.self) {
      (r, presenter: UINavigationController?, searchKeyword: String) in
      return SearchResultListCoordinator(presenter: presenter, text: searchKeyword)
    }
  }
  
  func searchHistoryCoordinator(container: Container) {
    container.register(SearchHistoryCoordinator.self) {
      (r, presenter: UINavigationController?, searchType: SearchType)in
      return SearchHistoryCoordinator(presenter: presenter, searchType: searchType)
    }
  }
}
