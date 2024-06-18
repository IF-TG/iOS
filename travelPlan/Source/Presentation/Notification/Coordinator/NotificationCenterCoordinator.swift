//
//  NotificationCenterCoordinator.swift
//  travelPlan
//
//  Created by 양승현 on 10/27/23.
//

import UIKit
import SHCoordinator
import SHFirestoreService

protocol NotificationCenterCoordinatorDependencies {
  func makeNotificationCenterViewController() -> NotificationCenterViewController
}

protocol NotificationCenterCoordinatorDelegate: AnyObject {
  func finish()
}

final class NotificationCenterCoordinator: FlowCoordinator {
  // MARK: - Properties
  var parent: FlowCoordinator?
  var child: [FlowCoordinator] = []
  var presenter: UINavigationController?
  var dependencies: NotificationCenterCoordinatorDependencies
  
  // MARK: - Lifecycle
  init(
    presenter: UINavigationController?,
    dependencies: NotificationCenterCoordinatorDependencies
  ) {
    self.presenter = presenter
    self.dependencies = dependencies
  }
  
  func start() {
    let vc = dependencies.makeNotificationCenterViewController()
    vc.coordinator = self
    presenter?.pushViewController(vc, animated: true)
  }
  
  deinit {
    print("\(Self.self) deinit" )
  }
}

// MARK: - NotificationCenterCoordinatorDelegate
extension NotificationCenterCoordinator: NotificationCenterCoordinatorDelegate { }
