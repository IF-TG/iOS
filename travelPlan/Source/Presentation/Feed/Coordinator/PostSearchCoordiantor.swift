//
//  PostSearchCoordiantor.swift
//  travelPlan
//
//  Created by 양승현 on 2023/07/02.
//

import UIKit
import SHCoordinator

final class PostSearchCoordinator: FlowCoordinator {
  
  // MARK: - Properties
  var parent: FlowCoordinator?
  var child: [FlowCoordinator] = []
  var presenter: UINavigationController?
  private let searchType: SearchType
  
  // MARK: - LifeCycle
  init(presenter: UINavigationController?, searchType: SearchType) {
    self.presenter = presenter
    self.searchType = searchType
  }
  
  deinit {
    print("deinit: \(Self.self)")
  }
  
  // MARK: - Helpers
  func start() {
    let actions = PostSeaerchActions(
      showTourDestinationList: { [weak self] text in self?.showTourDestinationList(text: text) },
      showPostList: { [weak self] text in self?.showPostList(text: text) },
      pop: { [weak self] in self?.pop() }
    )
    
    let viewModel = DefaultPostSearchViewModel(searchType: searchType, actions: actions)
    let viewController = PostSearchViewController(viewModel: viewModel)
    
    presenter?.pushViewController(viewController, animated: false)
  }
}

// MARK: - Private Helpers
extension PostSearchCoordinator {
  private func showTourDestinationList(text: String) {
    let childCoordinator = SearchResultListCoordinator(presenter: presenter)
    addChild(with: childCoordinator)
  }
  
  private func showPostList(text: String) {
    // TODO: - 피드 검색 결과 vc 구현하고 coordinator 추가해야됨
  }
  
  private func pop() {
    finish(withAnimated: false)
  }
}
