//
//  FavoriteDetailCoordinator.swift
//  travelPlan
//
//  Created by 양승현 on 10/9/23.
//

import UIKit
import SHCoordinator

protocol FavoriteDetailCoordinatorDelegate: AnyObject {
  func finish()
}

final class FavoriteDetailCoordinator: FlowCoordinator {
  // MARK: - Properties
  var parent: FlowCoordinator!
  var child: [FlowCoordinator] = []
  var presenter: UINavigationController!
  
  private var direcrotyIdentifier: AnyHashable
  
  init(presenter: UINavigationController, direcotryIdentifier identifier: AnyHashable) {
    self.presenter = presenter
    direcrotyIdentifier = identifier
  }
  
  // MARK: - Helpers
  func start() {
    let vc = FavoriteDetailViewController()
    vc.coordinator = self
    presenter.pushViewController(vc, animated: true)
  }
}

// MARK: - FavoriteCoordinatorDelegate
extension FavoriteDetailCoordinator: FavoriteDetailCoordinatorDelegate {}
