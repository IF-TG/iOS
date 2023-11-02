//
//  LoginCoordinator.swift
//  travelPlan
//
//  Created by 양승현 on 2023/06/30.
//

import UIKit
import SHCoordinator

protocol LoginCoordinatorDelegate: FlowCoordinatorDelegate {
  func showFeedPage()
}

final class LoginCoordinator: FlowCoordinator {
  // MARK: - Properties
  var parent: FlowCoordinator?
  var child: [FlowCoordinator] = []
  let presenter: UINavigationController?
  weak var viewController: UIViewController?

  // MARK: - Lifecycle
  init(presenter: UINavigationController?) {
    self.presenter = .init()
  }
  
  func start() {
    let loginVM = LoginViewModel()
    let loginViewController = LoginViewController(vm: loginVM)
    viewController = loginViewController
    loginViewController.coordinator = self
    presenter?.viewControllers = [loginViewController]
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
