//
//  PostSearchCoordiantor.swift
//  travelPlan
//
//  Created by 양승현 on 2023/07/02.
//

import UIKit
import SHCoordinator

protocol PostSearchCoordinatorDelegate: FlowCoordinatorDelegate { }

final class PostSearchCoordinator: FlowCoordinator {
  // MARK: - Nested
  enum SearchType {
    case travelDestination
    case post
  }
  
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
    let viewModel = DefaultPostSearchViewModel()
    let viewController = PostSearchViewController(viewModel: viewModel)
    viewController.coordinator = self
    presenter?.pushViewController(viewController, animated: false)
  }
}

// MARK: - PostSearchCoordinatorDelegate 
extension PostSearchCoordinator: PostSearchCoordinatorDelegate {
  func showNext() {
    switch searchType {
    case .post:
      // TODO: - 피드 검색 결과 vc 구현하고 coordinator 추가해야됨
      break
    case .travelDestination:
      let childCoordinator = SearchResultListCoordinator(presenter: presenter)
      addChild(with: childCoordinator)
    }
  }
}
