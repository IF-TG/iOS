//
//  FavoriteCoordinator.swift
//  travelPlan
//
//  Created by 양승현 on 2023/06/30.
//

import UIKit
import SHCoordinator

protocol FavoriteCoordinatorDelegate: AnyObject {
  func finish()
  func showDetailPage(with id: AnyHashable)
  func showNewDirectoryCreationPage()
}

final class FavoriteCoordinator: FlowCoordinator {
  // MARK: - Properties
  var parent: FlowCoordinator!
  var child: [FlowCoordinator] = []
  var presenter: UINavigationController!
  weak var viewController: FavoriteViewController!
  
  init(presenter: UINavigationController) {
    self.presenter = presenter
  }
  
  // MARK: - Helpers
  func start() {
    let viewModel = FavoriteViewModel()
    let vc = FavoriteViewController(viewModel: viewModel)
    viewController = vc
    vc.coordinator = self
    presenter.pushViewController(vc, animated: true)
  }
}

// MARK: - FavoriteCoordinatorDelegate
extension FavoriteCoordinator: FavoriteCoordinatorDelegate {
  func showDetailPage(with id: AnyHashable) {
    let childCoordinator = FavoriteDetailCoordinator(presenter: presenter, direcotryIdentifier: id)
    addChild(with: childCoordinator)
  }
  
  func showNewDirectoryCreationPage() {
    let settingView = FavoriteDirectorySettingView(title: "폴더 추가")
    settingView.delegate = self
    let settingViewController = BaseBottomSheetViewController(
      mode: .couldBeFull,
      radius: 25,
      isShowedKeyBoard: true)
    settingViewController.setContentView(settingView)
    settingViewController.dismissHandler = {
      settingView.hideKeyboard()
    }
    settingView.setSearchBarInputAccessory(settingViewController.view.subviews.first!)
    viewController.presentBottomSheet(settingViewController) {
      settingView.showKeyboard()
    }
  }
}

// MARK: - FavoriteDirectorySettingViewDelegate
extension FavoriteCoordinator: FavoriteDirectorySettingViewDelegate {
  func favoriteDirectorySettingView(
    _ settingView: FavoriteDirectorySettingView,
    didTapOkButton: UIButton
  ) {
    presenter.presentedViewController?.dismiss(animated: false)
    let directoryTitle = settingView.text
    viewController.makeANewDirectory(with: directoryTitle)
    
  }
  
  func bottomSheetView(
    _ bottomSheetView: BottomSheetView,
    withPenGesture gesture: UIPanGestureRecognizer
  ) { }
}
