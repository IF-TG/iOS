//
//  MyInformationCoordinator.swift
//  travelPlan
//
//  Created by 양승현 on 3/16/24.
//

import UIKit
import SHCoordinator
import Alamofire

protocol MyInformationCoordinatorDelegate: AnyObject {
  func finish()
}

final class MyInformationCoordinator: FlowCoordinator {
  var parent: FlowCoordinator?
  var child: [FlowCoordinator] = []
  
  var presenter: UINavigationController?
  
  init(presenter: UINavigationController?) {
    self.presenter = presenter
  }
  
  func start() {
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
    let mockMyProfileUseCase = MockMyProfileUseCase()
    let viewModel = MyInformationViewModel(myProfileUseCase: mockMyProfileUseCase)
    let viewController = MyInformationViewController(viewModel: viewModel)
    presenter?.pushViewController(viewController, animated: true)
  }
}

extension MyInformationCoordinator: MyInformationCoordinatorDelegate { }
