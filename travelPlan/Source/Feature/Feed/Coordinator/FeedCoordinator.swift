//
//  FeedCoordinator.swift
//  travelPlan
//
//  Created by 양승현 on 2023/06/30.
//

import UIKit
import SHCoordinator

protocol FeedCoordinatorDelegate: FlowCoordinatorDelegate {
  func showPostSearch()
  func showNotification()
  func showTotalBottomSheet()
  func showPostMainThemeFilteringBottomSheet(sortingType: TravelMainThemeType)
  func showPostOrderFilteringBottomSheet()
  func showReviewWrite()
  func showPostDetailPage()
}

final class FeedCoordinator: FlowCoordinator {
  // MARK: - Properties
  var parent: FlowCoordinator?
  var child: [FlowCoordinator] = []
  var presenter: UINavigationController?
  
  private weak var viewController: FeedViewController?
  
  init(presenter: UINavigationController?) {
    self.presenter = presenter
  }
  
  // MARK: - Helpers
  func start() {
    let feedViewModel = FeedViewModel()
    let vc = FeedViewController(viewModel: feedViewModel)
    viewController = vc
    vc.coordinator = self
    presenter?.pushViewController(vc, animated: true)
  }
}

// MARK: - FeedCoordinatorDelegate
extension FeedCoordinator: FeedCoordinatorDelegate {
  func showPostDetailPage() {
    presenter?.pushViewController(PostDetailViewController(viewModel: PostDetailViewModel()), animated: true)
  }
  
  func showPostSearch() {
    let childCoordinator = PostSearchCoordinator(presenter: presenter)
    addChild(with: childCoordinator)
  }
  
  func showNotification() {
    let childCoordinator = NotificationCenterCoordinator(presenter: presenter)
    addChild(with: childCoordinator)
  }
  
  func showTotalBottomSheet() {
    let sheetViewController = PostViewBottomSheetViewController()
    presenter?.present(sheetViewController, animated: false)
  }
  
  func showPostMainThemeFilteringBottomSheet(sortingType: TravelMainThemeType) {
    var bottomSheetViewController: PostFilteringBottomSheetViewController
    if sortingType.rawValue == "지역" {
      bottomSheetViewController = PostFilteringBottomSheetViewController(
        bottomSheetMode: .full,
        sortingType: .travelMainTheme(.region(.busan)))
    } else {
      bottomSheetViewController = PostFilteringBottomSheetViewController(
        bottomSheetMode: .couldBeFull,
        sortingType: .travelMainTheme(sortingType))
    }
    bottomSheetViewController.delegate = viewController
    presenter?.presentBottomSheet(bottomSheetViewController)
  }
  
  func showPostOrderFilteringBottomSheet() {
    let bottomSheetViewController = PostFilteringBottomSheetViewController(
      bottomSheetMode: .couldBeFull,
      sortingType: .travelOrder)
    bottomSheetViewController.delegate = viewController
    presenter?.presentBottomSheet(bottomSheetViewController)
  }
  
  func showReviewWrite() {
    let reviewWritingCoordinator = ReviewWritingCoordinator(presenter: presenter)
    addChild(with: reviewWritingCoordinator)
  }
}
