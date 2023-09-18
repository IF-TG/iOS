//
//  FeedCoordinator.swift
//  travelPlan
//
//  Created by 양승현 on 2023/06/30.
//

import UIKit
import SHCoordinator

protocol FeedCoordinatorDelegate: AnyObject {
  func finish()
  func gotoPostSearchPage()
}

final class FeedCoordinator: FlowCoordinator {
  // MARK: - Properties
  var parent: FlowCoordinator!
  var child: [FlowCoordinator] = []
  var presenter: UINavigationController!
  
  init(presenter: UINavigationController!) {
    self.presenter = presenter
  }
  
  // MARK: - Helpers
  func start() {
    let vc = FeedViewController()
    vc.coordinator = self
    presenter.pushViewController(vc, animated: true)
  }
}

// MARK: - FeedCoordinatorDelegate
extension FeedCoordinator: FeedCoordinatorDelegate {
  func gotoPostSearchPage() {
    // TODO: - post search coordaintor로 이동해야 합니다.
    let childCoordinator = PostSearchCoordinator(presenter: presenter)
    addChild(with: childCoordinator)
  }
}
