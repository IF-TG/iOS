//
//  FavoriteCoordinator.swift
//  travelPlan
//
//  Created by 양승현 on 2023/06/30.
//

import UIKit
import SHCoordinator

final class FavoriteCoordinator: FlowCoordinator {
  // MARK: - Properties
  var parent: FlowCoordinator!
  var child: [FlowCoordinator] = []
  var presenter: UINavigationController!
  private weak var viewController: UIViewController!
  private var settingIndex: Int?
  
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

// MARK: - Private Helpers
extension FavoriteCoordinator {
  func makeSettingBottomSheetViewController(
    mode: BaseBottomSheetViewController.ContentMode,
    contentView: FavoriteDirectorySettingView
  ) -> BaseBottomSheetViewController {
    let settingViewController = BaseBottomSheetViewController(mode: mode, radius: 25, isShowedKeyBoard: true)
    settingViewController.setContentView(contentView)
    settingViewController.dismissHandler = {
      contentView.hideKeyboard()
    }
    contentView.setSearchBarInputAccessory(settingViewController.view.subviews.first)
    contentView.delegate = self
    return settingViewController
  }
}

// MARK: - FavoriteCoordinatorDelegate
extension FavoriteCoordinator: FavoriteCoordinatorDelegate {
  func showDetailPage(with id: AnyHashable, title: String) {
    let childCoordinator = FavoriteDetailCoordinator(presenter: presenter, direcotryIdentifier: id, title: title)
    addChild(with: childCoordinator)
  }
  
  func showNewDirectoryCreationPage() {
    let settingView = FavoriteDirectorySettingView(settingState: .newDirectory)
    let settingViewController = makeSettingBottomSheetViewController(
      mode: .couldBeFull,
      contentView: settingView)
    viewController.presentBottomSheet(settingViewController) {
      settingView.showKeyboard()
    }
  }
  
  func showDirectoryNameSettingPage(with index: Int) {
    settingIndex = index
    let settingView = FavoriteDirectorySettingView(settingState: .name)
    let settingViewController = makeSettingBottomSheetViewController(
      mode: .couldBeFull,
      contentView: settingView)
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
    guard let viewController = self.viewController as? FavoriteViewController else { return }
    let title = settingView.text
    switch settingView.settingState {
    case .newDirectory:
      viewController.makeNewDirectory(with: title)
    case .name:
      guard let settingIndex, let title else {
        // FIXME: - 에러 알림창. 일단 0번 업데이트로 설정
        viewController.updateDirectoryName(title: title ?? "미정", index: 0)
        return
      }
      viewController.updateDirectoryName(title: title, index: settingIndex)
    }
  }
}
