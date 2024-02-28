//
//  ProfileCoordinator.swift
//  travelPlan
//
//  Created by 양승현 on 2023/06/30.
//

import UIKit
import SHCoordinator
import Alamofire

protocol ProfileCoordinatorDelegate: AnyObject {
  func finish()
  func showOperationGuidePage()
  func showMyInformationPage()
  func showCustomerServicePage()
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
extension ProfileCoordinator: ProfileCoordinatorDelegate {
  func showOperationGuidePage() {
    let operationGuidePage = OperationGuideViewController(navigationTitle: "이용안내")
    presenter?.pushViewController(operationGuidePage, animated: true)
  }
  
  func showMyInformationPage() {
    let session = SessionProvider(session: .default)
    let userInfoRepository = DefaultUserInfoRepository(service: session)
    let userInfoUseCase = DefaultUserInfoUseCase(userInfoRepository: userInfoRepository)
    let viewModel = MyInformationViewModel(userInfoUseCase: userInfoUseCase)
    let viewController = MyInformationViewController(viewModel: viewModel)
    presenter?.pushViewController(viewController, animated: true)
  }
  
  func showCustomerServicePage() {
    let viewController = CustomerServiceViewController(navigationTitle: "고객센터")
    presenter?.pushViewController(viewController, animated: true)
  }
}
