//
//  NotificationCenterCoordinator.swift
//  travelPlan
//
//  Created by 양승현 on 10/27/23.
//

import UIKit
import SHCoordinator

protocol NotificationCenterCoordinatorDelegate: AnyObject {
  func finish()
}

final class NotificationCenterCoordinator: FlowCoordinator {
  // MARK: - Properties
  var parent: FlowCoordinator!
  var child: [FlowCoordinator] = []
  var presenter: UINavigationController!
  
  init(presenter: UINavigationController?) {
    self.presenter = presenter
  }
  
  func start() {
    let vc = NotificationCenterViewController()
    presenter.pushViewController(vc, animated: true)
  }
}

extension NotificationCenterCoordinator: NotificationCenterCoordinatorDelegate { }
