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
  
  private var viewController: UIViewController?
  
  init(presenter: UINavigationController?) {
    self.presenter = presenter
    viewController = NotificationCenterViewController()
  }
  
  func start() {
    
  }
}
