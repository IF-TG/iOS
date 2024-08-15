//
//  MyInformationCoordinator.swift
//  travelPlan
//
//  Created by 양승현 on 3/16/24.
//

import UIKit
import SHCoordinator
import Combine
import SHFirestoreService

protocol MyInformationCoordinatorDependencies {
  func makeMyInformationViewController(with actions: MyInformationViewModelActions) -> UIViewController
  func makeMyInformationAlbumSheetViewController() -> UIViewController
}

final class MyInformationCoordinator: FlowCoordinator {
  // MARK: - Properties
  var parent: FlowCoordinator?
  var child: [FlowCoordinator] = []
  
  var presenter: UINavigationController?
  
  private weak var viewController: UIViewController?
  
  private let dependencies: MyInformationCoordinatorDependencies
  
  private var alubmImageChoiceSubscription: AnyCancellable?
  
  private let profileImageMemoryCache = ImageMemoryCache()
  
  // MARK: - Lifecycle
  init(presenter: UINavigationController?, dependencies: MyInformationCoordinatorDependencies) {
    self.presenter = presenter
    self.dependencies = dependencies
  }
  
  func start() {
    let _viewController = dependencies.makeMyInformationViewController(with: makeActions())
    self.viewController = _viewController
    presenter?.pushViewController(_viewController, animated: true)
  }
  
  // MARK: - Helpers
  func makeActions() -> MyInformationViewModelActions {
    return MyInformationViewModelActions { [weak self] in
      self?.showConfirmationAlertPage()
    } showBottomSheetAlbum: { [weak self] in
      self?.showBottomSheetAlbum()
    } showAlertForError: { [weak self] description, completion in
      self?.showAlertForError(with: description, completion: completion)
    } finish: { [weak self] in
      self?.finish()
    } finishWithAnimation: { [weak self] animate in
      self?.finish(withAnimated: animate)
    }
  }
}

// MARK: - Actions Helpers
extension MyInformationCoordinator {
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
