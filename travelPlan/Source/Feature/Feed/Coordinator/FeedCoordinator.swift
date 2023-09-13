//
//  FeedCoordinator.swift
//  travelPlan
//
//  Created by 양승현 on 2023/06/30.
//

import UIKit
import SHCoordinator

final class FeedCoordinator: FlowCoordinator {
  // MARK: - Properties
  var parent: FlowCoordinator!
  var child: [FlowCoordinator] = []
  var presenter: UINavigationController
  var viewController: UIViewController!
  
  init(presenter: UINavigationController) {
    self.presenter = presenter
    let vc = FeedViewController()
    vc.coordinator = self
    viewController = vc
  }
  
  // MARK: - Helpers
  func start() {
    presenter.pushViewController(viewController, animated: true)
  }
}

extension FeedCoordinator {
  func gotoPostSearchPage() {
    // coordinator settingTODO: - post search coordaintor로 이동해야 합니다.
    let childCoordinator = PostSearchCoordinator(presenter: presenter)
    addChild(with: childCoordinator)
  }
  
  func gotoTotalBottomSheetPage() {
    let sheetViewController = PostViewBottomSheetViewController()
    presenter.present(sheetViewController, animated: false)
  }
  
  func gotoSortBottomSheetPage() {
  }
}
