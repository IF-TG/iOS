//
//  PostSearchCoordiantor.swift
//  travelPlan
//
//  Created by 양승현 on 2023/07/02.
//

import UIKit
import SHCoordinator

final class PostSearchCoordinator: FlowCoordinator {
  // MARK: - Properties
  var parent: FlowCoordinator!
  var child: [FlowCoordinator] = []
  var presenter: UINavigationController
  var viewController: UIViewController!
  
  // MARK: - LifeCycle
  init(presenter: UINavigationController) {
    self.presenter = presenter
    let vc = PostSearchViewController()
    vc.coordinator = self
    viewController = vc
  }
  
//  deinit {
//    print("DEBUG: \(String(describing: self)) deinit")
//  }
  
  // MARK: - Helpers
  func start() {
    presenter.pushViewController(viewController, animated: true)
  }
}
