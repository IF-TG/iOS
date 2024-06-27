//
//  LoginCoordinator.swift
//  travelPlan
//
//  Created by 양승현 on 2023/06/30.
//

import UIKit
import SHCoordinator
import SHFirestoreService

protocol LoginCoordinatorDependencies {
  func makeLoginViewController() -> LoginViewController
}

protocol LoginCoordinatorDelegate: FlowCoordinatorDelegate {
  func showFeedPage()
}

final class LoginCoordinator: FlowCoordinator {
  // MARK: - Properties
  var parent: FlowCoordinator?
  var child: [FlowCoordinator] = []
  var presenter: UINavigationController?
  private let dependencies: any LoginCoordinatorDependencies

  // MARK: - Lifecycle
  init(presenter: UINavigationController?, dependencies: any LoginCoordinatorDependencies) {
    self.presenter = .init()
    self.dependencies = dependencies
  }
  
  func start() {
    presenter?.viewControllers = [dependencies.makeLoginViewController()]
//    loginViewController.coordinator = self
  }
  
  deinit {
    print("삭제요~ \(Self.self)")
  }
}

// MARK: - LoginCoordinatorDelegate
extension LoginCoordinator: LoginCoordinatorDelegate {
  func showFeedPage() {
    guard let parent = parent as? ApplicationCoordinator else {
      NSLog("DEBUG: Parent is not applicationCoordinator")
      return
    }
    parent.gotoMainTapFeedPage(withDelete: self)
  }
}
