//
//  DestinationDetailCoordinator.swift
//  travelPlan
//
//  Created by SeokHyun on 7/31/24.
//

import UIKit
import SHCoordinator

protocol DestinationDetailCoordinatorDependencies {
  func makeDestinationDetailViewController(
    destinationId: DestinationIdEntity,
    actions: DestinationDetailViewModelActions
  ) -> DestinationDetailViewController
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
    let actions = DestinationDetailViewModelActions(pop: { [weak self] in
      self?.pop()
    })
    let viewController = dependencies.makeDestinationDetailViewController(
      destinationId: destinationId,
      actions: actions
    )
    presenter?.pushViewController(viewController, animated: true)
  }
}

extension DestinationDetailCoordinator {
  private func pop() {
    finish(withAnimated: true)
  }
}
