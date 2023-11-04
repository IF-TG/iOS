//
//  ReviewWritingCoordinator.swift
//  travelPlan
//
//  Created by SeokHyun on 11/4/23.
//

import UIKit
import SHCoordinator

protocol ReviewWritingCoordinatorDelegate: FlowCoordinatorDelegate {
  
}

final class ReviewWritingCoordinator: FlowCoordinator {
  // MARK: - Properties
  var parent: FlowCoordinator?
  var child: [FlowCoordinator] = []
  var presenter: UINavigationController?
  
  func start() {
    let vc = ReviewWritingViewController()
    vc.coordinator = self
    presenter?.pushViewController(vc, animated: true)
  }
  
  // MARK: - LifeCycle
  init(presenter: UINavigationController?) {
    self.presenter = presenter
  }
  
  deinit {
    print("deinit: \(Self.self)")
  }
}

extension ReviewWritingCoordinator: ReviewWritingCoordinatorDelegate {
  
}
