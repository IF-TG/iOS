//
//  ProfileCoordinator.swift
//  travelPlan
//
//  Created by 양승현 on 2023/06/30.
//

import UIKit
import SHCoordinator

final class ProfileCoordinator: FlowCoordinator {
  // MARK: - Properties
  var parent: FlowCoordinator!
  var child: [FlowCoordinator] = []
  var presenter: UINavigationController
  var viewController: UIViewController!
  
  init(presenter: UINavigationController) {
    self.presenter = presenter
    let vc = ProfileViewController()
    vc.coordinator = self
    viewController = vc
  }
  
  // MARK: - Helpers
  func start() {
    presenter.pushViewController(viewController, animated: true)
  }
}
