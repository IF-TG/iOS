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
  }
  
  deinit {
    print("deinit: \(Self.self)")
  }
  
  // MARK: - Helpers
  func start() {
    let viewController = PostSearchViewController()
    viewController.coordinator = self
    presenter.pushViewController(viewController, animated: true)
  }
}
