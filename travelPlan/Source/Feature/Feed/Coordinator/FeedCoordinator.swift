//
//  FeedCoordinator.swift
//  travelPlan
//
//  Created by 양승현 on 2023/06/30.
//

import UIKit
import SHCoordinator

protocol FeedCoordinatorDelegate: AnyObject {
  func finish()
  func showPostSearch()
  func showTotalBottomSheet()
  func showTravelThemeBottomSheet(sortingType: TravelMainThemeType)
  func showTravelTrendBottomSheet()
  func showReviewWrite()
}

final class FeedCoordinator: FlowCoordinator {
  // MARK: - Properties
  var parent: FlowCoordinator!
  var child: [FlowCoordinator] = []
  var presenter: UINavigationController!
  
  init(presenter: UINavigationController!) {
    self.presenter = presenter
  }
  
  // MARK: - Helpers
  func start() {
    let feedViewModel = FeedViewModel()
    let vc = FeedViewController(viewModel: feedViewModel)
    vc.coordinator = self
    presenter.pushViewController(vc, animated: true)
  }
}

// MARK: - FeedCoordinatorDelegate
extension FeedCoordinator: FeedCoordinatorDelegate {
  func showPostSearch() {
    // coordinator settingTODO: - post search coordaintor로 이동해야 합니다.
    let childCoordinator = PostSearchCoordinator(presenter: presenter)
    addChild(with: childCoordinator)
  }
  
  func showTotalBottomSheet() {
    let sheetViewController = PostViewBottomSheetViewController()
    presenter.present(sheetViewController, animated: false)
  }
  
  func showTravelThemeBottomSheet(sortingType: TravelMainThemeType) {
    var viewController: TravelThemeBottomSheetViewController
    if sortingType.rawValue == "지역" {
      viewController = TravelThemeBottomSheetViewController(
        bottomSheetMode: .full,
        sortingType: .detailCategory(.region(.busan)))
    } else {
      viewController = TravelThemeBottomSheetViewController(
        bottomSheetMode: .couldBeFull,
        sortingType: .detailCategory(sortingType))
    }
    if let feedVC = presenter.viewControllers.last as? FeedViewController {
      viewController.delegate = feedVC
    }
    presenter.presentBottomSheet(viewController)
  }
  
  func showTravelTrendBottomSheet() {
    let viewController = TravelThemeBottomSheetViewController(
      bottomSheetMode: .couldBeFull,
      sortingType: .trend)
    if let feedVC = presenter.viewControllers.last as? FeedViewController {
      viewController.delegate = feedVC
    }
    presenter.presentBottomSheet(viewController)
  }
  
  func showReviewWrite() {
    let viewController = TravelReviewViewController()
    presenter.pushViewController(viewController, animated: true)
  }
}
