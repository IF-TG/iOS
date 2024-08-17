//
//  SearchCoordinator.swift
//  travelPlan
//
//  Created by 양승현 on 2023/06/30.
//

import UIKit
import SHCoordinator

protocol SearchCoordinatorDependencies: AnyObject {
  func makeSearchViewController(actions: SearchViewModelActions) -> SearchViewController
  
  func makeSearchMoreDetailCoordinator(
    presenter: UINavigationController?
  ) -> SearchMoreDetailCoordinator
  
  func makeSearchHistoryCoordinator(
    presenter: UINavigationController?,
    searchType: SearchType
  ) -> SearchHistoryCoordinator
  
  func makeDestinationDetailCoordinator(
    presenter: UINavigationController?,
    destinationId: DestinationIdEntity
  ) -> DestinationDetailCoordinator
}

final class SearchCoordinator: FlowCoordinator {
  // MARK: - Dependencies
  private let dependencies: any SearchCoordinatorDependencies
  var presenter: UINavigationController?
  
  // MARK: - Properties
  var parent: FlowCoordinator?
  var child: [FlowCoordinator] = []
  
  // MARK: - LifeCycle
  init(presenter: UINavigationController?, dependencies: any SearchCoordinatorDependencies) {
    self.presenter = presenter
    self.dependencies = dependencies
  }
  
  deinit {
    print("deinit: \(Self.self)")
  }
  
  // MARK: - Helpers
  func start() {
    let actions = SearchViewModelActions(
      showSearchMoreDetail: { [weak self] destinationInfos, title, searchSection in
        self?.showSearchMoreDetail(
          destinationInfos: destinationInfos,
          headerTitle: title,
          searchSection: searchSection
        )
      },
      showDestinationDetail: { [weak self] destinationId in self?.showDetail(destinationId: destinationId) },
      showSearchHistory: { [weak self] in self?.showSearchHistory() }
    )
    
    let viewController = dependencies.makeSearchViewController(actions: actions)
    presenter?.viewControllers = [viewController]
  }
}

extension SearchCoordinator {
  private func showDetail(destinationId: DestinationIdEntity) {
    let child = dependencies.makeDestinationDetailCoordinator(
      presenter: presenter,
      destinationId: destinationId
    )
    addChild(with: child)
  }
  
  private func showSearchMoreDetail(
    destinationInfos: [TravelDestinationInfo],
    headerTitle: String,
    searchSection: SearchSectionIndex
  ) {
    let searchDetailCoordinator = dependencies.makeSearchMoreDetailCoordinator(presenter: presenter)
    
    child.append(searchDetailCoordinator)
    searchDetailCoordinator.parent = self
    searchDetailCoordinator.start(
      destinationInfos: destinationInfos,
      headerTitle: headerTitle,
      searchSection: searchSection
    )
  }
  
  private func showSearchHistory() {
    let child = dependencies.makeSearchHistoryCoordinator(presenter: presenter, searchType: .travelDestination)
    addChild(with: child)
  }
}
