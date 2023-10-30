//
//  LoginCoordinator.swift
//  travelPlan
//
//  Created by 양승현 on 2023/06/30.
//

import UIKit
import SHCoordinator

protocol LoginCoordinatorDelegate: FlowCoordinatorDelegate {
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
  
}

// MARK: - LoginCoordinatorDelegate
extension LoginCoordinator: LoginCoordinatorDelegate {
}
