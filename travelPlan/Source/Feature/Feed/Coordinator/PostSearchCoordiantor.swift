//
//  PostSearchCoordiantor.swift
//  travelPlan
//
//  Created by 양승현 on 2023/07/02.
//

import UIKit
import SHCoordinator

protocol PostSearchCoordinatorDelegate: AnyObject {
  func finish()
}

final class PostSearchCoordinator: FlowCoordinator {
  // MARK: - Properties
  var parent: FlowCoordinator!
  var child: [FlowCoordinator] = []
  var presenter: UINavigationController!
  
  // MARK: - LifeCycle
  init(presenter: UINavigationController) {
    self.presenter = presenter
  }

  // MARK: - Helpers
  func start() {
    let vc = PostSearchViewController()
    vc.coordinator = self
    presenter.pushViewController(vc, animated: true)
  }
}

// MARK: - PostSearchCoordinatorDelegate 
extension PostSearchCoordinator: PostSearchCoordinatorDelegate {
}
