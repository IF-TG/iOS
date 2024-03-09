//
//  SearchMoreDetailCoordinator.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/09/16.
//

import UIKit
import SHCoordinator

protocol SearchMoreDetailCoordinatorDelegate: FlowCoordinatorDelegate { }

final class SearchMoreDetailCoordinator: FlowCoordinator {
  // MARK: - Properties
  var parent: FlowCoordinator?
  var child: [FlowCoordinator] = []
  var presenter: UINavigationController?
  var viewControllerType: SearchSectionType
  
  // MARK: - LifeCycle
  init(presenter: UINavigationController?, viewControllerType: SearchSectionType) {
    self.viewControllerType = viewControllerType
    self.presenter = presenter
  }
  
  deinit {
    print("deinit: \(Self.self)")
  }
  
  // MARK: - Start
  func start() {
    let viewController = SearchMoreDetailViewController(type: viewControllerType)
    viewController.coordinator = self
    presenter?.pushViewController(viewController, animated: true)
  }
}

extension SearchMoreDetailCoordinator: SearchMoreDetailCoordinatorDelegate {
  
}
