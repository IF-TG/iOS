//
//  DestinationDetailCoordinator.swift
//  travelPlan
//
//  Created by SeokHyun on 7/31/24.
//

import UIKit
import SHCoordinator

protocol DestinationDetailCoordinatorDependencies {
  func makeDestinationDetailViewController() -> DestinationDetailViewController
}

final class DestinationDetailCoordinator: FlowCoordinator {
  // MARK: - Properties
  var parent: (any SHCoordinator.FlowCoordinator)?
  var child: [any SHCoordinator.FlowCoordinator] = []
  var presenter: UINavigationController?
  private let dependencies: DestinationDetailCoordinatorDependencies
  
  // MARK: - LifeCycle
  init(
    presenter: UINavigationController?,
    dependencies: DestinationDetailCoordinatorDependencies
  ) {
    self.presenter = presenter
    self.dependencies = dependencies
  }
  
  deinit {
    print("deinit: \(Self.self)")
  }
  
  // MARK: - Start
  func start() {
    let viewController = dependencies.makeDestinationDetailViewController()
    presenter?.pushViewController(viewController, animated: true)
  }
}
