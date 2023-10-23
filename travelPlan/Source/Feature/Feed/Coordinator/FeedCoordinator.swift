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
  
  private weak var viewController: FeedViewController?
  
  init(presenter: UINavigationController!) {
    self.presenter = presenter
  }
  
  // MARK: - Helpers
  func start() {
    let feedViewModel = FeedViewModel()
    let vc = FeedViewController(viewModel: feedViewModel)
    viewController = vc
    vc.coordinator = self
    presenter.pushViewController(vc, animated: true)
  }
}

// MARK: - FeedCoordinatorDelegate
extension FeedCoordinator: FeedCoordinatorDelegate {
  func showPostSearch() {
    let childCoordinator = PostSearchCoordinator(presenter: presenter)
    addChild(with: childCoordinator)
  }
  
  func showTotalBottomSheet() {
    let sheetViewController = PostViewBottomSheetViewController()
    presenter.present(sheetViewController, animated: false)
  }
  
  func showTravelThemeBottomSheet(sortingType: TravelMainThemeType) {
    var bottomSheetViewController: TravelThemeBottomSheetViewController
    if sortingType.rawValue == "지역" {
      bottomSheetViewController = TravelThemeBottomSheetViewController(
        bottomSheetMode: .full,
        sortingType: .travelMainTheme(.region(.busan)))
    } else {
      bottomSheetViewController = TravelThemeBottomSheetViewController(
        bottomSheetMode: .couldBeFull,
        sortingType: .travelMainTheme(sortingType))
    }
    bottomSheetViewController.delegate = viewController
    presenter.presentBottomSheet(bottomSheetViewController)
  }
  
  func showTravelTrendBottomSheet() {
    let bottomSheetViewController = TravelThemeBottomSheetViewController(
      bottomSheetMode: .couldBeFull,
      sortingType: .travelOrder)
    bottomSheetViewController.delegate = viewController
    presenter.presentBottomSheet(bottomSheetViewController)
  }
  
  func showReviewWrite() {
    let reviewViewController = TravelReviewViewController()
    presenter.pushViewController(reviewViewController, animated: true)
  }
}
