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
  // swiftlint:disable:next function_body_length
  func assemble(container: Swinject.Container) {
    let appDIContainer = AppDIContainer.shared
    
    // TODO: - Login Flow Coordinator
    
    // MARK: - PostDetail Flow Coordinator
    container.register(
      PostDetailCoordinator.self
    ) { (_, presenter: UINavigationController?, post: Post?, postId: PostIdentifier) in
      return PostDetailCoordinator(presenter: presenter, post: post, postId: postId)
    }
    
    // MARK: - Notification Flow Coordinator
    container.register(NotificationCenterCoordinator.self) { (_, presenter: UINavigationController?) in
      return NotificationCenterCoordinator(presenter: presenter, dependencies: appDIContainer)
    }
    
    // TODO: - Album Page
    
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
    
    // FIXME: - Search Flow Coordinator.
    container.register(SearchCoordinator.self) { (_, presenter: UINavigationController) in
      SearchCoordinator(presenter: presenter)
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
