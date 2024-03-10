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
    let sessionConfiguration = URLSessionConfiguration.default
    sessionConfiguration.timeoutIntervalForRequest = 5
    let monitor = ClosureEventMonitor()
    monitor.requestDidResume = { request in print("MyInformationVC task 요청 시자그!: \(request)") }
    monitor.requestDidFinish = { request in print("MyInformationVC 요청 끝: \(request)") }
    monitor.taskDidComplete = { _, _, error in
      if let error = error {
        print("Task completed with error: \(error)")
      } else {
        print("Task completed successfully")
      }
    }
    //let session = Session(configuration: sessionConfiguration, eventMonitors: [monitor])
    let mockUserInfoUseCase = MockUserInfoUseCase()
    let viewModel = MyInformationViewModel(userInfoUseCase: mockUserInfoUseCase)
    let viewController = MyInformationViewController(viewModel: viewModel)
    presenter?.pushViewController(viewController, animated: true)
  }
  
  func showCustomerServicePage() {
    let viewController = CustomerServiceViewController(navigationTitle: "고객센터")
    presenter?.pushViewController(viewController, animated: true)
  }
}
