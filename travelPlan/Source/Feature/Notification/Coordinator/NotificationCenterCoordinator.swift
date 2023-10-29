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
  
  // MARK: - Lifecycle
  init(presenter: UINavigationController?) {
    self.presenter = presenter
  }
  
  func start() {
    let vc = NotificationCenterViewController()
    vc.coordinator = self
    presenter.pushViewController(vc, animated: true)
  }
  
  deinit {
    print("\(Self.self) deinit" )
  }
}

// MARK: - NotificationCenterCoordinatorDelegate
extension NotificationCenterCoordinator: NotificationCenterCoordinatorDelegate { }
