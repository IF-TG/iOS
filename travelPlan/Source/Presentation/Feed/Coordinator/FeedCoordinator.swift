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
    let categoryPageViewModel = CategoryPageViewModel()
    let pageViews = makeFeedPageViews(with: categoryPageViewModel)
    let vc = FeedViewController(
      viewModel: feedViewModel,
      categoryPageViewModel: categoryPageViewModel, 
      pageViews: pageViews)
    viewController = vc
    vc.coordinator = self
    presenter?.pushViewController(vc, animated: true)
  }
  
  private func makeFeedPageViews(
    with categoryPageViewModel: CategoryPageViewDataSource
  ) -> [UIViewController] {
    return (0..<categoryPageViewModel.numberOfItems).map {
      let feedCategory = categoryPageViewModel.postSearchFilterItem(at: $0)
      if $0 + 1 == categoryPageViewModel.numberOfItems {
        return DevelopmentViewController()
      }
      // FIXME: - 실제로 서버 통신하게된다면 DefaultPostUseCase 써야합니다.
      // 지금은 페이징 테스트때문에 MockPostUseCaseForPaging을 사용합니다.
      // MockPostRepository()를 통해서 실제 서버의 resopnseDTO를 decodable한 데이터들을 처럼
      // mock json을 받을 수 있지만 포스트가 3개 정보밖에 없습니다.
      // let postUseCase = DefaultPostUseCase(postRepository: MockPostRepository())
      let mockPostUseCase = MockPostUseCaseForPaging()
      let viewModel = FeedPostViewModel(postCategory: feedCategory, postUseCase: mockPostUseCase)
      return FeedPostViewController(
        type: feedCategory,
        viewModel: viewModel)
    }
  }
}

// MARK: - FeedCoordinatorDelegate
extension FeedCoordinator: FeedCoordinatorDelegate {  
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
