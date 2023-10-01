//
//  SearchCoordinator.swift
//  travelPlan
//
//  Created by 양승현 on 2023/06/30.
//

import UIKit
import SHCoordinator

protocol SearchCoordinatorDelegate: AnyObject {
  func showSearchDetail(type: SearchSectionType)
  func finish()
}

final class SearchCoordinator: FlowCoordinator {
  // MARK: - Properties
  var parent: FlowCoordinator!
  var child: [FlowCoordinator] = []
  var presenter: UINavigationController!
  
  // MARK: - LifeCycle
  init(presenter: UINavigationController!) {
    self.presenter = presenter
  }
  
  deinit {
    print("deinit: \(Self.self)")
  }
  
  // MARK: - Helpers
  func start() {
    let viewController = SearchViewController()
    viewController.coordinator = self
    presenter.viewControllers = [viewController]
    print(presenter.viewControllers)
  }
}

// MARK: - SearchCoordinatorDelegate
extension SearchCoordinator: SearchCoordinatorDelegate {
  func showSearchDetail(type: SearchSectionType) {
    let child = SearchMoreDetailCoordinator(presenter: presenter, viewControllerType: type)
    addChild(with: child)
  }
}
