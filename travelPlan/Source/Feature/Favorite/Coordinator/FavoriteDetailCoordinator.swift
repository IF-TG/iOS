//
//  FavoriteDetailCoordinator.swift
//  travelPlan
//
//  Created by 양승현 on 10/9/23.
//

import UIKit
import SHCoordinator

protocol FavoriteDetailCoordinatorDelegate: FlowCoordinatorDelegate { }

final class FavoriteDetailCoordinator: FlowCoordinator {
  // MARK: - Properties
  var parent: FlowCoordinator?
  var child: [FlowCoordinator] = []
  var presenter: UINavigationController?
  
  var viewController: UIViewController
  
  init(presenter: UINavigationController?, direcotryIdentifier identifier: AnyHashable, title: String) {
    self.presenter = presenter
    // TODO: - 뷰모델 생성시 특별한 식별자 주입 identifier주입
    // direcrotyIdentifier = identifier
    let favoriteDetailViewController = FavoriteDetailViewController(title: title)
    viewController = favoriteDetailViewController
    favoriteDetailViewController.coordinator = self
  }
  
  // MARK: - Helpers
  func start() {
    presenter?.pushViewController(viewController, animated: true)
  }
}

// MARK: - FavoriteCoordinatorDelegate
extension FavoriteDetailCoordinator: FavoriteDetailCoordinatorDelegate {
}
