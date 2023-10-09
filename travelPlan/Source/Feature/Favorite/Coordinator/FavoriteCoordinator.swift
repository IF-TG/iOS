//
//  FavoriteCoordinator.swift
//  travelPlan
//
//  Created by 양승현 on 2023/06/30.
//

import UIKit
import SHCoordinator

protocol FavoriteCoordinatorDelegate: AnyObject {
  func finish()
  func showDetailPage(with id: AnyHashable)
}

final class FavoriteCoordinator: FlowCoordinator {
  // MARK: - Properties
  var parent: FlowCoordinator!
  var child: [FlowCoordinator] = []
  var presenter: UINavigationController!
  
  init(presenter: UINavigationController) {
    self.presenter = presenter
  }
  
  // MARK: - Helpers
  func start() {
    let viewModel = FavoriteViewModel()
    let vc = FavoriteViewController(viewModel: viewModel)
    vc.coordinator = self
    presenter.pushViewController(vc, animated: true)
  }
}

// MARK: - FavoriteCoordinatorDelegate
extension FavoriteCoordinator: FavoriteCoordinatorDelegate {
  func showDetailPage(with id: AnyHashable) {
    let childCoordinator = FavoriteDetailCoordinator(presenter: presenter, direcotryIdentifier: id)
    addChild(with: childCoordinator)
  }
}
