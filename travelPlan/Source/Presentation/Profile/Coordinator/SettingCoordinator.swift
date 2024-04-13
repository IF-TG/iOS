//
//  SettingCoordinator.swift
//  travelPlan
//
//  Created by 양승현 on 2023/06/30.
//

import UIKit
import SHCoordinator
import Alamofire

protocol SettingCoordinatorDelegate: FlowCoordinatorDelegate {
  func showOperationGuidePage()
  func showMyInformationPage()
  func showCustomerServicePage()
}

final class SettingCoordinator: FlowCoordinator {
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

// MARK: - SettingCoordinatorDelegate
extension SettingCoordinator: SettingCoordinatorDelegate {
  func showOperationGuidePage() {
    let operationGuidePage = OperationGuideViewController(navigationTitle: "이용안내")
    presenter?.pushViewController(operationGuidePage, animated: true)
  }
  
  func showMyInformationPage() {
    let childCoordinator = MyInformationCoordinator(presenter: presenter)
    addChild(with: childCoordinator)
  }
  
  func showCustomerServicePage() {
    let viewController = CustomerServiceViewController(navigationTitle: "고객센터")
    presenter?.pushViewController(viewController, animated: true)
  }
}
