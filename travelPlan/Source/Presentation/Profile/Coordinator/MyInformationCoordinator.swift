//
//  MyInformationCoordinator.swift
//  travelPlan
//
//  Created by 양승현 on 3/16/24.
//

import UIKit
import SHCoordinator
import Alamofire
import Combine

protocol MyInformationCoordinatorDelegate: FlowCoordinatorDelegate {
  func showConfirmationAlertPage()
  func showBottomSheetAlbum()
  func showAlertForError(with description: String, completion: (() -> Void)?)
}

final class MyInformationCoordinator: FlowCoordinator {
  var parent: FlowCoordinator?
  var child: [FlowCoordinator] = []
  
  var presenter: UINavigationController?
  
  var viewController: UIViewController?
  
  var alubmImageChoiceSubscription: AnyCancellable?
  
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
    // let session = Session(configuration: sessionConfiguration, eventMonitors: [monitor])
    let mockMyProfileUseCase = MockMyProfileUseCase()
    let mockUserStorage = MockUserStorage()
    let loggedInUserRepository = DefaultLoggedInUserRepository(storage: mockUserStorage)
    let loggedInUserUseCase = DefaultLoggedInUserUseCase(loggedInUserRepository: loggedInUserRepository)
    let viewModel = MyInformationViewModel(
      myProfileUseCase: mockMyProfileUseCase,
      loggedInUserUseCase: loggedInUserUseCase)
    let viewController = MyInformationViewController(viewModel: viewModel)
    viewController.coordinator = self
    self.viewController = viewController
    presenter?.pushViewController(viewController, animated: true)
  }
}

extension MyInformationCoordinator: MyInformationCoordinatorDelegate {
  func showConfirmationAlertPage() {
    let alert = UIAlertController(title: nil, message: "프로필을 수정하지 않으시겠습니까?", preferredStyle: .alert)
    let yes = UIAlertAction(title: "예", style: .default) { [weak self] _ in
      self?.finish(withAnimated: true)
    }
    let no = UIAlertAction(title: "아니요", style: .cancel)
    [yes, no].forEach { alert.addAction($0) }
    viewController?.present(alert, animated: true, completion: nil)
  }
  
  func showBottomSheetAlbum() {
    let albumSheet = MyInformationAlbumSheetViewController()
    alubmImageChoiceSubscription = albumSheet.$hasSelectedProfile
      .subscribe(on: DispatchQueue.main)
      .compactMap { $0 }
      .sink { [weak self] image in
        (self?.viewController as? MyInformationViewController)?.handleSelectedImage(with: image)
      }
    viewController?.presentBottomSheet(albumSheet)
  }
  
  func showAlertForError(with description: String, completion: (() -> Void)?) {
    let alert = UIAlertController(title: nil, message: description, preferredStyle: .alert).set {
      $0.addAction(UIAlertAction(title: "OK", style: .default) { _ in
        completion?()
      })
    }
    viewController?.present(alert, animated: true)
  }
}
