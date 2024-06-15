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
  var parent: FlowCoordinator?
  var child: [FlowCoordinator] = []
  var presenter: UINavigationController?
  
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
    let viewModel = DefaultSearchViewModel(actions: actions)
    let viewController = SearchViewController(viewModel: viewModel)
    presenter?.viewControllers = [viewController]
  }
}

extension SearchCoordinator {
  private func showSearchDetail(type: SearchSectionType) {
    let child = SearchMoreDetailCoordinator(presenter: presenter, viewControllerType: type)
    addChild(with: child)
  }
  
  private func showPostSearch() {
    let child = PostSearchCoordinator(presenter: presenter, searchType: .travelDestination)
    addChild(with: child)
  }
}
