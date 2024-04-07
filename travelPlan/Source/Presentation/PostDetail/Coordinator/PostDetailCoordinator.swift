//
//  PostDetailCoordinator.swift
//  travelPlan
//
//  Created by 양승현 on 4/2/24.
//

import UIKit
import SHCoordinator

protocol PostDetailCoordinatorDelegate: FlowCoordinatorDelegate {
  func showAlertForError(with description: String, completion: (() -> Void)?)
  func showAnAlertToAskWhetherToCancelWrittingTheReply(completion: ((Bool) -> Void)?)
  func showOption(handler: ((PostDetailOption) -> Void)?)
  func showPostAuthorBlock(_ authorName: String, handler: ((Bool) -> Void)?)
  /// 신고하기 종류 추가.
  func showPostReport(handler: ((PostReportType) -> Void)?)
  func showPostReportResult(wtih option: PostDetailOption)
}

// MARK: - PostDetailCoordinator
final class PostDetailCoordinator: NSObject, FlowCoordinator {
  var parent: FlowCoordinator?
  var child: [FlowCoordinator] = []
  var presenter: UINavigationController?
  
  /// dismiss호출코드에서 finish도 해줘야합니다
  private let postDetailViewController: PostDetailViewController
  
  init(presenter: UINavigationController?, post: Post, category: Post.Category) {
    self.presenter = presenter
    let mockPostRepository = MockPostRepository()
    let postUseCase = DefaultPostUseCase(postRepository: mockPostRepository)
    
    let mockPostCommentRepository = MockPostCommentRepository()
    let postCommentUseCase = DefaultPostCommentUseCase(postCommentRepository: mockPostCommentRepository)
    
    let mockUserStorage = MockUserStorage()
    let loggedInUserRepository = DefaultLoggedInUserRepository(storage: mockUserStorage)
    let loggedInUserUseCase = DefaultLoggedInUserUseCase(loggedInUserRepository: loggedInUserRepository)
    
    let mockPostNestedCommentRepository = MockPostNestedCommentRepository()
    let postNestedCommentUseCase = DefaultPostNestedCommentUseCase(
      postNestedCommentRepository: mockPostNestedCommentRepository)
    
    let mockUserBlockRepository = MockWrappedUserBlockRepository()
    let userBlockUseCase = DefaultUserBlockUseCase(userBlockRepository: mockUserBlockRepository)
    
    let postDetailVM = PostDetailViewModel(
      post: post,
      category: category,
      postUseCase: postUseCase,
      postCommentUseCase: postCommentUseCase,
      loggedInUserUseCase: loggedInUserUseCase, 
      postNestedCommentUseCase: postNestedCommentUseCase,
      userBlockUseCase: userBlockUseCase)
    postDetailViewController = PostDetailViewController(viewModel: postDetailVM)
    super.init()
    presenter?.delegate = self
  }
  
  func start() {
    postDetailViewController.coordinator = self
    presenter?.pushViewController(postDetailViewController, animated: true)
  }
}

// MARK: - PostDetailCoordinatorDelegate
extension PostDetailCoordinator: PostDetailCoordinatorDelegate {
  func showAlertForError(with description: String, completion: (() -> Void)?) {
    let alert = UIAlertController(title: nil, message: description, preferredStyle: .alert).set {
      $0.addAction(title: "OK", style: .default) { _ in completion?() }
    }
    postDetailViewController.present(alert, animated: true)
  }
  
  func showAnAlertToAskWhetherToCancelWrittingTheReply(completion: ((Bool) -> Void)?) {
    let alert = UIAlertController(title: "작성 중인 대댓글을 취소하시겠습니까?", message: nil, preferredStyle: .alert).set {
      $0.addAction(title: "아니요", style: .cancel) { _ in completion?(false) }
      $0.addAction(title: "예", style: .default) { _ in completion?(true) }
    }
    postDetailViewController.present(alert, animated: true)
  }
  
  func showOption(handler: ((PostDetailOption) -> Void)?) {
    /// 액션시트에서 cancel은 하나밖에 안됩니다.
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    PostDetailOption.allCases.forEach { option in
      alert.addAction(title: option.rawValue, style: .destructive) { _ in handler?(option) }
    }
    alert.addAction(title: "취소", style: .cancel, handler: nil)
    presenter?.present(alert, animated: true)
  }
  
  func showPostAuthorBlock(_ authorName: String, handler: ((Bool) -> Void)?) {
    let alert = UIAlertController(
      title: "‘\(authorName)’님을 차단하시겠습니까?",
      message: "이 유저의 모든 게시물이 보이지 않고\n회원님에게 좋아요, 댓글을 남길 수 없으며\n팔로우가 취소됩니다.",
      preferredStyle: .alert
    ).set {
      $0.addAction(title: "취소", style: .cancel) { _ in handler?(false) }
      $0.addAction(title: "차단", style: .destructive) { _ in handler?(true) }
    }
    presenter?.present(alert, animated: true)
  }
  
  func showPostReport(handler: ((PostReportType) -> Void)?) {
    let alert = UIAlertController(title: "신고하기", message: nil, preferredStyle: .alert)
    PostReportType.allCases.forEach { report in
      var isStoppedRequest = false
      if report == .stopRequest { isStoppedRequest = true }
      alert.addAction(title: report.toKorean, style: isStoppedRequest ? .destructive : .default) { _ in
        handler?(report)
      }
    }
    presenter?.present(alert, animated: true, completion: nil)
  }
  
  func showPostReportResult(wtih option: PostDetailOption) {
    switch option {
    case .postBlock:
      presenter?.present(PostOptionResultAlertController(type: .postAuthorBlock), animated: true)
    case .postReport:
      presenter?.present(PostOptionResultAlertController(type: .postReport), animated: true)
    }
  }
}

// MARK: - Fileprivate Helpers
fileprivate extension UIAlertController {
  func addAction(title: String, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)?) {
    self.addAction(UIAlertAction(title: title, style: style, handler: handler))
  }
}

// MARK: - FlowCoordinatorNavigatable
extension PostDetailCoordinator: FlowCoordinatorNavigatable {
  var viewController: UIViewController? {
    postDetailViewController
  }
}

// MARK: - UINavigationControllerDelegate
extension PostDetailCoordinator: UINavigationControllerDelegate {
  func navigationController(
    _ navigationController: UINavigationController,
    didShow viewController: UIViewController,
    animated: Bool
  ) {
    handlePopViewController(navigationController, didShow: viewController, animated: animated)
  }
}
