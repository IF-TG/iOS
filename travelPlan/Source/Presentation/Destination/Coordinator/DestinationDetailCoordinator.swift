//
//  DestinationDetailCoordinator.swift
//  travelPlan
//
//  Created by SeokHyun on 7/31/24.
//

import UIKit
import SHCoordinator

protocol DestinationDetailCoordinatorDependencies {
  func makeDestinationDetailViewController(destinationId: DestinationIdEntity) -> DestinationDetailViewController
}

final class DestinationDetailCoordinator: FlowCoordinator {
  // MARK: - Properties
  var parent: (any SHCoordinator.FlowCoordinator)?
  var child: [any SHCoordinator.FlowCoordinator] = []
  var presenter: UINavigationController?
  private let dependencies: any DestinationDetailCoordinatorDependencies
  private let destinationId: DestinationIdEntity
  
  // MARK: - LifeCycle
  init(
    presenter: UINavigationController?,
    dependencies: any DestinationDetailCoordinatorDependencies,
    destinationId: DestinationIdEntity
  ) {
    self.presenter = presenter
    self.dependencies = dependencies
    self.destinationId = destinationId
  }
  
  deinit {
    print("deinit: \(Self.self)")
  }
  
  // MARK: - Start
  func start() {
    let viewController = dependencies.makeDestinationDetailViewController(destinationId: destinationId)
    presenter?.pushViewController(viewController, animated: true)
  }
}
