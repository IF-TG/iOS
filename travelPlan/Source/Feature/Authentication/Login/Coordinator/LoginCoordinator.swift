//
//  LoginCoordinator.swift
//  travelPlan
//
//  Created by 양승현 on 2023/06/30.
//

import UIKit
import SHCoordinator

final class LoginCoordinator: FlowCoordinator {
  // MARK: - Properties
  var parent: FlowCoordinator!
  var child: [FlowCoordinator] = []
  let presenter: UINavigationController
  var viewController: UIViewController!

  // MARK: - Lifecycle
  init() {
    let loginVM = LoginViewModel()
    let loginViewController = LoginViewController(vm: loginVM)
    self.presenter = .init(rootViewController: loginViewController)
    viewController = loginViewController
    loginViewController.coordinator = self
  }
  
  func start() {
    presenter.viewControllers = [viewController]
  }
  
}

// MARK: - Goto child coordinator
extension LoginCoordinator {
  
}
