//
//  SettingCoordinator.swift
//  travelPlan
//
//  Created by 양승현 on 2023/06/30.
//

import UIKit
import SHCoordinator
import Alamofire

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
    let actions = SettingViewModelActions { [weak self] in
      self?.showOperationGuidePage()
    } showMyInformationPage: { [weak self] in
      self?.showMyInformationPage()
    } showCustomerServicePage: { [weak self] in
      self?.showCustomerServicePage()
    } finish: { [weak self] in
      self?.finish()
    }
    
    let mockUserStorage = StubOwnerStorage()
    let loggedInUserRepository = DefaultLoggedInUserRepository(storage: mockUserStorage)
    let loggedInUserUseCase = DefaultLoggedInUserUseCase(loggedInUserRepository: loggedInUserRepository)
    
    let viewModel = SettingViewModel(loggedInUserUseCase: loggedInUserUseCase, actions: actions)

    let vc = SettingViewController(viewModel: viewModel)
    presenter?.pushViewController(vc, animated: true)
  }
}

// MARK: - Actions Helpers
extension SettingCoordinator {
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
