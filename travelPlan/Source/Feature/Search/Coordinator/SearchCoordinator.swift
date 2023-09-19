//
//  SearchCoordinator.swift
//  travelPlan
//
//  Created by 양승현 on 2023/06/30.
//

import UIKit
import SHCoordinator

final class SearchCoordinator: FlowCoordinator {
  // MARK: - Properties
  var parent: FlowCoordinator!
  var child: [FlowCoordinator] = []
  var presenter: UINavigationController
  var viewController: UIViewController!
  
  init(presenter: UINavigationController) {
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
  }
  
  func showSearchDetail(type: SearchSectionType) {
    let child = SearchDetailCoordinator(presenter: presenter, type: type)
    addChild(with: child)
  }
}
