//
//  ProfileCoordinator.swift
//  travelPlan
//
//  Created by 양승현 on 2023/06/30.
//

import UIKit
import SHCoordinator

protocol ProfileCoordinatorDelegate: AnyObject {
  func finish()
}

final class ProfileCoordinator: FlowCoordinator {
  // MARK: - Properties
  var parent: FlowCoordinator?
  var child: [FlowCoordinator] = []
  var presenter: UINavigationController?
  
  init(presenter: UINavigationController?) {
    self.presenter = presenter
  }
  
  // MARK: - Helpers
  func start() {
    let vc = SettingViewController()
    vc.coordinator = self
    presenter?.pushViewController(vc, animated: true)
  }
}

// MARK: - ProfileCoordinatorDelegate
extension ProfileCoordinator: ProfileCoordinatorDelegate {}
