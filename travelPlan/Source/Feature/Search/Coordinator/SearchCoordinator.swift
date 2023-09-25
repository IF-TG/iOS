//
//  SearchCoordinator.swift
//  travelPlan
//
//  Created by 양승현 on 2023/06/30.
//

import UIKit
import SHCoordinator

protocol SearchCoordinatorDelegate: AnyObject {
  func finish()
}

final class SearchCoordinator: FlowCoordinator {
  // MARK: - Properties
  var parent: FlowCoordinator!
  var child: [FlowCoordinator] = []
  var presenter: UINavigationController!
  
  init(presenter: UINavigationController!) {
    self.presenter = presenter
  }
  
  // MARK: - Helpers
  func start() {
    let vc = SearchViewController()
    vc.coordinator = self
    presenter.pushViewController(vc, animated: true)
  }
}

// MARK: - SearchCoordinatorDelegate
extension SearchCoordinator: SearchCoordinatorDelegate { }
