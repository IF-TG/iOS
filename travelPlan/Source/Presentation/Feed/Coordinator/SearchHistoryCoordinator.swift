//
//  SearchHistoryCoordinator.swift
//  travelPlan
//
//  Created by 양승현 on 2023/07/02.
//

import UIKit
import SHCoordinator

protocol SearchHistoryCoordinatorDependencies {
  func makeSearchHistoryViewController(
    actions: SearchHistoryViewModelActions,
    searchType: SearchType
  ) -> SearchHistoryViewController
  
  func makeSearchResultListCoordinator(
    presenter: UINavigationController?,
    searchKeyword: String
  ) -> SearchResultListCoordinator
  
  // TODO: -  make포스트 검색 결과 coordinator
}

final class SearchHistoryCoordinator: FlowCoordinator {
  // MARK: - Dependencies
  private let dependencies: SearchHistoryCoordinatorDependencies = AppDIContainer.shared
  var presenter: UINavigationController?
  
  // MARK: - Properties
  var parent: FlowCoordinator?
  var child: [FlowCoordinator] = []
  private let searchType: SearchType
  
  // MARK: - LifeCycle
  init(presenter: UINavigationController?, searchType: SearchType) {
    self.presenter = presenter
    self.searchType = searchType
  }
  
  deinit {
    print("deinit: \(SearchHistoryCoordinator.self)")
  }
  
  // MARK: - Helpers
  func start() {
    let actions = SearchHistoryViewModelActions(
      showTravelDestinationList: { [weak self] searchKeyword in
        self?.showTravelDestinationList(searchKeyword: searchKeyword) },
      showPostList: { [weak self] text in 
        self?.showPostList(text: text) },
      pop: { [weak self] in 
        self?.pop() }
    )
    
    let viewController = dependencies.makeSearchHistoryViewController(actions: actions, searchType: searchType)
    presenter?.pushViewController(viewController, animated: false)
  }
}

// MARK: - Private Helpers
extension SearchHistoryCoordinator {
  private func showTravelDestinationList(searchKeyword: String) {
    let childCoordinator = dependencies.makeSearchResultListCoordinator(
      presenter: presenter,
      searchKeyword: searchKeyword
    )
    addChild(with: childCoordinator)
  }
  
  private func showPostList(text: String) {
    // TODO: - 피드 검색 결과 vc 구현하고 coordinator 추가해야됨
    print("DEBUG: 피드 검색 결과 vc 구현하고 coordinator 추가해야됨")
  }
  
  private func pop() {
    finish(withAnimated: false)
  }
}
