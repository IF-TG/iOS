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
    presenter: UINavigationController?,
    viewControllerType: SearchSectionType
  ) -> SearchMoreDetailCoordinator
  
  func makeSearchHistoryCoordinator(
    presenter: UINavigationController?,
    searchType: SearchType
  ) -> SearchHistoryCoordinator
}

final class SearchCoordinator: FlowCoordinator {
  // MARK: - Dependencies
  private let dependencies: SearchCoordinatorDependencies = AppDIContainer.shared
  var presenter: UINavigationController?
  
  // MARK: - Properties
  var parent: FlowCoordinator?
  var child: [FlowCoordinator] = []
  
  // MARK: - LifeCycle
  init(presenter: UINavigationController?) {
    self.presenter = presenter
  }
  
  deinit {
    print("deinit: \(Self.self)")
  }
  
  // MARK: - Helpers
  func start() {
    let actions = SearchViewModelActions(
      showSearchDetail: { [weak self] type in self?.showSearchDetail(type: type) },
      showSearchHistory: { [weak self] in self?.showSearchHistory() }
    )
    
    let viewController = dependencies.makeSearchViewController(actions: actions)
    presenter?.viewControllers = [viewController]
  }
}

extension SearchCoordinator {
  private func showSearchDetail(type: SearchSectionType) {
    let child = dependencies.makeSearchMoreDetailCoordinator(
      presenter: presenter,
      viewControllerType: type
    )
    addChild(with: child)
  }
  
  private func showSearchHistory() {
    let child = dependencies.makeSearchHistoryCoordinator(presenter: presenter, searchType: .travelDestination)
    addChild(with: child)
  }
}
