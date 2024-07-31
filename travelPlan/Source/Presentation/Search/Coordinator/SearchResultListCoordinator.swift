//
//  SearchResultListCoordinator.swift
//  travelPlan
//
//  Created by SeokHyun on 5/31/24.
//

import UIKit
import SHCoordinator

protocol SearchResultListCoordinatorDelegate: FlowCoordinatorDelegate { }

protocol SearchResultListCoordinatorDependencies: AnyObject {
  func makeSearchResultListViewController(
    actions: SearchResultListViewModelActions,
    text: String
  ) -> SearchResultListViewController
  // TODO: - DestinationDetailCoordinator 만들어야 함
//  func makeDestinationDetailCoordinator() -> DestinationDetailCoordinator
}

final class SearchResultListCoordinator: FlowCoordinator {
  // MARK: - Dependencies
  private let dependencies: SearchResultListCoordinatorDependencies = AppDIContainer.shared
  var presenter: UINavigationController?
  
  // MARK: - Properties
  var parent: (any FlowCoordinator)?
  var child: [any FlowCoordinator] = []
  private let text: String
  
  // MARK: - LifeCycle
  init(presenter: UINavigationController?, text: String) {
    self.presenter = presenter
    self.text = text
  }
  
  deinit {
    print("deinit: \(Self.self)")
  }
  
  // MARK: - Start
  func start() {
    let actions = SearchResultListViewModelActions(
      pop: { [weak self] in self?.pop() },
      showDetail: { [weak self] in self?.showDetail() }
    )
    
    let viewController = dependencies.makeSearchResultListViewController(actions: actions, text: text)
    presenter?.pushViewController(viewController, animated: true)
  }
}

extension SearchResultListCoordinator {
  private func pop() {
    guard let parent = parent else { return }
    
    var presentCoordinator: FlowCoordinator = self
    var parentCoordinator: FlowCoordinator = parent
    
    while !(presentCoordinator is SearchCoordinator) {
      presentCoordinator.child.removeAll()
      
      guard let removeCoordinator = parentCoordinator.child.first(where: { $0 === presentCoordinator }) else {
        print("DEBUG: Delete target \(presentCoordinator) is not available in child coordinators")
        return
      }
      
      for (index, childCoordinator) in parentCoordinator.child.enumerated()
      where childCoordinator === removeCoordinator {
        parentCoordinator.child.remove(at: index)
      }
      
      presentCoordinator = parentCoordinator
      guard let parent = presentCoordinator.parent else { return }
      parentCoordinator = parent
    }
    
    guard
      let toViewController = presentCoordinator.presenter?
        .viewControllers
        .first(where: { $0 is SearchViewController })
    else { return }
    
    presentCoordinator.presenter?.popToViewController(toViewController, animated: true)
  }
  
  private func showDetail() {
    // TODO: - DestinationDetailViewController를 호출해야 합니다.
  }
}
