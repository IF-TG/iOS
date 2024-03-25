//
//  ReviewWritingCoordinator.swift
//  travelPlan
//
//  Created by SeokHyun on 11/4/23.
//

import UIKit
import SHCoordinator

protocol ReviewWritingCoordinatorDelegate: FlowCoordinatorDelegate {
  func showPhotoViewController()
}

final class ReviewWritingCoordinator: FlowCoordinator {
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
  
  // MARK: - Helper
  func start() {
    let vc = ReviewWritingViewController()
    vc.coordinator = self
    presenter?.pushViewController(vc, animated: true)
  }
}

extension ReviewWritingCoordinator: ReviewWritingCoordinatorDelegate {
  func showPhotoViewController() {
    let childCoordinator = AlbumCoordinator(presenter: presenter)
    addChild(with: childCoordinator)
  }
}
