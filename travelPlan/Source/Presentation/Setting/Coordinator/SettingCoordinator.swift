//
//  SettingCoordinator.swift
//  travelPlan
//
//  Created by 양승현 on 2023/06/30.
//

import UIKit
import SHCoordinator
import Alamofire

protocol SettingCoordinatorDependencies {
  func makeSettingViewController(with actions: SettingViewModelActions) -> UIViewController
  func makeOperatingGuideViewController() -> UIViewController
  func makeMyInformationCoordinator(presenter: UINavigationController?) -> FlowCoordinator
  func makeCustomerServiceViewController() -> UIViewController
}

final class SettingCoordinator: FlowCoordinator {
  // MARK: - Properties
  var parent: FlowCoordinator?
  var child: [FlowCoordinator] = []
  var presenter: UINavigationController?
  
  private let dependencies: SettingCoordinatorDependencies
  
  init(presenter: UINavigationController?, dependencies: SettingCoordinatorDependencies) {
    self.presenter = presenter
    self.dependencies = dependencies
  }
  
  // MARK: - Helpers
  func start() {
    let viewController = dependencies.makeSettingViewController(with: makeActions())
    presenter?.pushViewController(viewController, animated: true)
  }
}

// MARK: - Public Helpers
extension SettingCoordinator {
  func makeActions() -> SettingViewModelActions {
    return SettingViewModelActions { [weak self] in
      self?.showOperationGuidePage()
    } showMyInformationPage: { [weak self] in
      self?.showMyInformationPage()
    } showCustomerServicePage: { [weak self] in
      self?.showCustomerServicePage()
    } finish: { [weak self] in
      self?.finish()
    }
  }
}

// MARK: - Actions Helpers
extension SettingCoordinator {
  func showOperationGuidePage() {
    let operationGuidePage = dependencies.makeOperatingGuideViewController()
    presenter?.pushViewController(operationGuidePage, animated: true)
  }
  
  func showMyInformationPage() {
    let childCoordinator = dependencies.makeMyInformationCoordinator(presenter: presenter)
    addChild(with: childCoordinator)
  }
  
  func showCustomerServicePage() {
    let viewController = dependencies.makeCustomerServiceViewController()
    presenter?.pushViewController(viewController, animated: true)
  }
}
