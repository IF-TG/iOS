//
//  AppDIContainer.swift
//  travelPlan
//
//  Created by 양승현 on 6/4/24.
//

import UIKit
import Swinject
import SHCoordinator

/// Assembler는 단 하나의 인스턴스만 생겨야 합니다. 또한 앱이 종료되기 전까지 메모리에 로드되어 있음이 보장되야 합니다.
/// Yeoga앱이 실행되기 위해 필요로되는 Layer별 assembly들을 한 곳에 모아 dependency를 관리합니다.
final class AppDIContainer {
  private(set) var assembler: Assembler
  
  private(set) var container: Swinject.Container
  
  var resolver: Resolver {
    assembler.resolver
  }
  
  static var shared = AppDIContainer()
  
  // MARK: - Lifecycle
  private init() {
    self.container = Container()
    self.assembler = Assembler([
      CoreAssembly(),
      PersistentStorageAssembly(),
      RepositoryAssembly(),
      DomainAssembly(),
      PresentationFeedAssembly(),
      PresentationAssembly()],
      container: container)
  }
  
  func lazyApplyAssemblies() {
    assembler.apply(assembly: FlowCoordinatorAssembly())
  }
}

// MARK: - AppCoordinatorDependencies
extension AppDIContainer: AppCoordinatorDependencies {
  func makeMainCoordinator() -> MainCoordinator {
    return resolve(MainCoordinator.self)!
  }
  
  func makeLoginCoordinator() -> LoginCoordinator {
    return resolve(LoginCoordinator.self)!
  }
}

// MARK: - MainCoordinatorDependencies
extension AppDIContainer: MainCoordinatorDependencies {
  func makeFeedCoordinator(presenter: UINavigationController) -> FeedCoordinator {
    return resolve(FeedCoordinator.self, argument: presenter)!
  }
  
  func makeSearchCoordinator(presenter: UINavigationController) -> SearchCoordinator {
    return resolve(SearchCoordinator.self, argument: presenter)!
  }
  
  func makePlanCoordinator(presenter: UINavigationController) -> PlanCoordinator {
    return resolve(PlanCoordinator.self, argument: presenter)!
  }
  
  func makeFavoriteCoordinator(presenter: UINavigationController) -> FavoriteCoordinator {
    return resolve(FavoriteCoordinator.self, argument: presenter)!
  }
  
  func makeSettingCoordinator(presenter: UINavigationController) -> SettingCoordinator {
    return resolve(SettingCoordinator.self, argument: presenter)!
  }
}

// MARK: - FeedCoordinatorDependencies
extension AppDIContainer: FeedCoordinatorDependencies {
  func makeFeedViewController(with coordinator: FeedCoordinator) -> FeedViewController {
    #if DEBUG
    return resolver.resolve(
      FeedViewController.self,
      name: .testDouble(.mock),
      argument: coordinator)!
    #else
    return resolver.resolve(
      FeedViewController.self,
      name: .implementation(.default),
      argument: coordinator)!
    #endif
  }
  
  func makePostDetailCoordinator(
    presenter: UINavigationController?,
    post: Post?,
    postId: Int32
  ) -> PostDetailCoordinator {
    return resolver.resolve(PostDetailCoordinator.self, arguments: presenter, post, postId)!
  }
  
  func makePostSearchCoordinator(
    presenter: UINavigationController?
  ) -> PostSearchCoordinator {
    return resolver.resolve(PostSearchCoordinator.self, argument: presenter)!
  }
  
  func makeNotificationCoordinator(
    presenter: UINavigationController?
  ) -> NotificationCenterCoordinator {
    return resolver.resolve(NotificationCenterCoordinator.self, argument: presenter)!
  }
  
  func makeReviewWritingCoordinator(
    presenter: UINavigationController?,
    mode: ReviewWritingMode
  ) -> ReviewWritingCoordinator {
    return resolver.resolve(ReviewWritingCoordinator.self, arguments: presenter, mode)!
  }
}
