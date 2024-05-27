//
//  FeedCoordinator.swift
//  travelPlan
//
//  Created by 양승현 on 2023/06/30.
//

import UIKit
import SHCoordinator

protocol FeedPostCoordinatorDelegate: AnyObject {
  func showDetailPost(post: Post, category: Post.Category, blockedPost: @escaping (Int32) -> Void)
}

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
    let concurrentBackgroundQueue = DispatchQueue(
      label: "backgroundQueue",
      qos: .userInitiated,
      attributes: .concurrent)
    let feedViewModel = FeedViewModel(backgroundQueue: concurrentBackgroundQueue)
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
      
      var viewModel: FeedPostViewModel
      
      #if DEBUG
      let mockPostFetchUseCase = MockPostFetchUseCase()
      viewModel = FeedPostViewModel(postCategory: feedCategory, postFetchUsecase: mockPostFetchUseCase)
      #else
      let service = SessionProvider()
      let ownerStroage = OwnerStorage()
      let defaultLoggedInUserRepository = DefaultLoggedInUserRepository(storage: ownerStorage)
      let defaultPostRepository = DefaultPostRepository(
        service: service,
        loggedInUserRepository: defaultLoggedInUserRepository)
      let defaultPostFetchUseCase = DefaultPostFetchUseCase(postRepository: defaultPostRepository)
      viewModel = FeedPostViewModel(
        postCategory: feedCategory,
        postFetchUsecase: defaultPostFetchUseCase)
      #endif
      return FeedPostViewController(type: feedCategory, viewModel: viewModel)
        .set { $0.coordinator = self }
    }
  }
}

// MARK: - FeedPostCoordinatorDelegate
extension FeedCoordinator: FeedPostCoordinatorDelegate {
  func showDetailPost(post: Post, category: Post.Category, blockedPost: @escaping (Int32) -> Void) {
    let childCoordinator = PostDetailCoordinator(presenter: presenter, post: post, category: category)
    childCoordinator.blockedPost = { blockedPostId in
      blockedPost(blockedPostId)
    }
    addChild(with: childCoordinator)
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
    let reviewWritingCoordinator = ReviewWritingCoordinator(presenter: presenter, mode: .new)
    addChild(with: reviewWritingCoordinator)
  }
}
