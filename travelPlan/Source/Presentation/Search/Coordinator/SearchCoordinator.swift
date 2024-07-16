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
  
  func makePostSearchCoordinator(
    presenter: UINavigationController?,
    searchType: SearchType
  ) -> PostSearchCoordinator
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
      showPostSearch: { [weak self] in self?.showPostSearch() }
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
  
  private func showPostSearch() {
    let child = dependencies.makePostSearchCoordinator(presenter: presenter, searchType: .travelDestination)
    addChild(with: child)
  }
}
