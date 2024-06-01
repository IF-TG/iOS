//
//  FeedCoordinator.swift
//  travelPlan
//
//  Created by 양승현 on 2023/06/30.
//

import UIKit
import SHCoordinator

protocol FeedPostCoordinatorDelegate: AnyObject {
  func showDetailPost(post: Post, blockedPost: @escaping (Int32) -> Void)
  func showPostShare(with activityItems: [Any])
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
  
  func showPostDetailFromUniversalLink(with postId: Int32) {
    /// 사용자가 공유하기로 포스트 상세화면을 들어갈 경우
    ///   차단하기 로직 실행시 메인 화면으로 전환시 해당 포스트가 존재하지 않기에, childCoordinator's blockedPost를 호출하지 않습니다.
    let childCoordinator = PostDetailCoordinator(presenter: presenter, post: nil, postId: postId)
    addChild(with: childCoordinator)
  }
  
  func showAlert(withTitle title: String, message: String) {
    let alert = UIAlertController(
      title: title,
      message: message,
      preferredStyle: .alert
    ).set {
      $0.addAction(UIAlertAction(title: "확인", style: .default))
    }
    presenter?.present(alert, animated: true)
  }
}

// MARK: - FeedPostCoordinatorDelegate
extension FeedCoordinator: FeedPostCoordinatorDelegate {
  func showDetailPost(post: Post, blockedPost: @escaping (Int32) -> Void) {
    let childCoordinator = PostDetailCoordinator(
      presenter: presenter,
      post: post,
      postId: Int32(post.detail.postID)!)
    childCoordinator.blockedPost = { blockedPostId in
      blockedPost(blockedPostId)
    }
    addChild(with: childCoordinator)
  }
  
  func showPostShare(with activityItems: [Any]) {
    let activityVC = UIActivityViewController(
      activityItems: activityItems,
      applicationActivities: nil)
    
    viewController?.present(activityVC, animated: true, completion: nil)
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
