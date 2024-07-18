//
//  FeedCoordinator.swift
//  travelPlan
//
//  Created by 양승현 on 2023/06/30.
//

import UIKit
import SHCoordinator

protocol FeedCoordinatorDependencies {
  /// 내부적으로 pageView들을 만듭니다.
  func makeFeedViewController(with coordinator: FeedCoordinator) -> FeedViewController
  func makePostDetailCoordinator(
    presenter: UINavigationController?,
    post: Post?,
    postId: PostIdentifier
  ) -> PostDetailCoordinator
  
  func makeSearchHistoryCoordinator(
    presenter: UINavigationController?,
    searchType: SearchType
  ) -> SearchHistoryCoordinator
  
  func makeNotificationCoordinator(presenter: UINavigationController?) -> NotificationCenterCoordinator
  func makeReviewWritingCoordinator(
    presenter: UINavigationController?,
    mode: ReviewWritingMode
  ) -> ReviewWritingCoordinator
}

protocol FeedPostCoordinatorDelegate: AnyObject {
  func showDetailPost(post: Post, blockedPost: @escaping (PostIdentifier) -> Void)
  func showPostShareSheet(with activityItem: PostActivityItemSource)
  func showAlertForError(with description: String, completion: (() -> Void)?)
  
  func showOption(handler: ((PostOption) -> Void)?)
  func showPostReport(handler: ((PostReportType) -> Void)?)
  func showPostReportResult(wtih option: PostOption)
  func showPostAuthorBlock(_ authorName: String, handler: ((Bool) -> Void)?)
}

protocol FeedCoordinatorDelegate: FlowCoordinatorDelegate {
  func showSearchHistory()
  func showNotification()
  func showTotalBottomSheet()
  func showPostMainThemeCategoryBottomSheet(mainTheme: TravelMainThemeType)
  func showPostOrderCategoryBottomSheet()
  func showReviewWrite()
  func showAlertForError(with description: String, completion: (() -> Void)?)
}

final class FeedCoordinator: FlowCoordinator, AlertCoordinatable, PostOptionCoordinatable, PostShareCoordinatable {
  // MARK: - Properties
  var parent: FlowCoordinator?
  
  var child: [FlowCoordinator] = []
  
  var presenter: UINavigationController?
  
  private let dependencies: FeedCoordinatorDependencies
  
  private weak var viewController: FeedViewController?
  
  init(presenter: UINavigationController?, dependencies: FeedCoordinatorDependencies) {
    self.presenter = presenter
    self.dependencies = dependencies
  }
  
  // MARK: - Helpers
  func start() {
    let feedViewController = dependencies.makeFeedViewController(with: self)
    viewController = feedViewController
    presenter?.pushViewController(feedViewController, animated: true)
  }
    
  func showPostDetailFromUniversalLink(with postId: PostIdentifier) {
    /// 사용자가 공유하기로 포스트 상세화면을 들어갈 경우
    ///   차단하기 로직 실행시 메인 화면으로 전환시 해당 포스트가 존재하지 않기에, childCoordinator's blockedPost를 호출하지 않습니다.
    let childCoordinator = dependencies.makePostDetailCoordinator(
      presenter: presenter,
      post: nil,
      postId: postId)
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
  
  func makePostOptionViewModelActions() -> PostOptionViewModelActions {
    return PostOptionViewModelActions { [weak self] optionCallBack in
        self?.showOption(handler: optionCallBack)
      } showPostOptionForMine: { [weak self] completion in
        self?.showPostOptionForMine(completion: completion)
      } showPostReport: { [weak self] reportCallback in
        self?.showPostReport(handler: reportCallback)
      } showPostReportResult: { [weak self] option in
        self?.showPostReportResult(wtih: option)
      } showPostAuthorBlock: { [weak self] authorName, completion in
        self?.showPostAuthorBlock(authorName, handler: completion)
      } showAlertForError: { [weak self] message, completion in
        self?.showAlertForError(with: message, completion: completion)
      }
  }
}

// MARK: - FeedPostCoordinatorDelegate
extension FeedCoordinator: FeedPostCoordinatorDelegate {
  func showDetailPost(post: Post, blockedPost: @escaping (PostIdentifier) -> Void) {
    let childCoordinator = dependencies.makePostDetailCoordinator(
      presenter: presenter,
      post: post,
      postId: post.detail.postID)
    
    childCoordinator.blockedPost = { blockedPostId in
      blockedPost(blockedPostId)
    }
    addChild(with: childCoordinator)
  }
}

// MARK: - FeedCoordinatorDelegate
extension FeedCoordinator: FeedCoordinatorDelegate {
  func showSearchHistory() {
    let childCoordinator = dependencies.makeSearchHistoryCoordinator(presenter: presenter, searchType: .post)
    addChild(with: childCoordinator)
  }
  
  func showNotification() {
    let childCoordinator = dependencies.makeNotificationCoordinator(presenter: presenter)
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
    let reviewWritingCoordinator = dependencies.makeReviewWritingCoordinator(presenter: presenter, mode: .new)
    addChild(with: reviewWritingCoordinator)
  }
}
