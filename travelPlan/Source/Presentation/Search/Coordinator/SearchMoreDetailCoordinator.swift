//
//  SearchMoreDetailCoordinator.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/09/16.
//

import UIKit
import SHCoordinator

protocol SearchMoreDetailCoordinatorDependencies {
  func makeSearchMoreDetailViewController(
    actions: SearchMoreDetailViewModelActions,
    destinationInfos: [TravelDestinationInfo],
    headerTitle: String,
    searchSection: SearchSectionIndex
  ) -> SearchMoreDetailViewController
  
  func makeDestinationDetailCoordinator(
    presenter: UINavigationController?,
    destinationIdEntity: DestinationIdEntity
  ) -> DestinationDetailCoordinator
}

final class SearchMoreDetailCoordinator: FlowCoordinator {
  // MARK: - Dependencies
  private let dependencies: any SearchMoreDetailCoordinatorDependencies
  
  // MARK: - Properties
  var parent: FlowCoordinator?
  var child: [FlowCoordinator] = []
  var presenter: UINavigationController?
  
  // MARK: - LifeCycle
  init(
    presenter: UINavigationController?,
    dependencies: any SearchMoreDetailCoordinatorDependencies
  ) {
    self.presenter = presenter
    self.dependencies = dependencies
  }
  
  deinit {
    print("deinit: \(Self.self)")
  }
  
  // MARK: - Start
  func start(
    destinationInfos: [TravelDestinationInfo],
    headerTitle: String,
    searchSection: SearchSectionIndex
  ) {
    let actions = SearchMoreDetailViewModelActions(
      showDestinationDetail: { [weak self] destinationId in
        self?.showDestinationDetail(destinationId: destinationId)
      },
      pop: { [weak self] in self?.pop() }
    )
    let viewController = dependencies.makeSearchMoreDetailViewController(
      actions: actions,
      destinationInfos: destinationInfos,
      headerTitle: headerTitle,
      searchSection: searchSection
    )
    presenter?.pushViewController(viewController, animated: true)
  }
  
  func start() { }
}

// MARK: - Private Helpers
extension SearchMoreDetailCoordinator {
  private func showDestinationDetail(destinationId: DestinationIdEntity) {
    let child = dependencies.makeDestinationDetailCoordinator(
      presenter: presenter,
      destinationIdEntity: destinationId
    )
    addChild(with: child)
  }
  
  private func pop() {
    finish(withAnimated: true)
  }
}
