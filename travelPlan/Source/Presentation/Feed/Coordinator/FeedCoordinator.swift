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
  func showPostMainThemeCategoryBottomSheet(mainTheme: TravelMainThemeType)
  func showPostOrderCategoryBottomSheet()
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
  
  // FIXME: - 피드 탭에서 분류, 정렬 title은 그대로 두고 이제 바텀시트 올라올 때 선택됬던거는 얕은 회식으로 표시?
  // 카테고리 선정시 옆에 태그 형식으로 붙여주는것도 괜찮은 선택지,,
  func showPostMainThemeCategoryBottomSheet(mainTheme: TravelMainThemeType) {
    let bottomSheet = PostMainThemeCategoryBottomSheet(mainTheme: mainTheme)
    bottomSheet.delegate = viewController
    presenter?.presentBottomSheet(bottomSheet)
  }
  
  func showPostOrderCategoryBottomSheet() {
    let bottomSheet = PostOrderCategoryBottomSheet()
    bottomSheet.delegate = viewController
    presenter?.presentBottomSheet(bottomSheet)
  }
  
  func showReviewWrite() {
    let reviewWritingCoordinator = ReviewWritingCoordinator(presenter: presenter)
    addChild(with: reviewWritingCoordinator)
  }
}
