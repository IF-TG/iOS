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
    
    let postDetailVM = PostDetailViewModel(
      post: post,
      category: category,
      postUseCase: postUseCase,
      postCommentUseCase: postCommentUseCase,
      loggedInUserUseCase: loggedInUserUseCase, 
      postNestedCommentUseCase: postNestedCommentUseCase)
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
      $0.addAction(title: "예", style: .default) { _ in completion?(true) }
      $0.addAction(title: "아니요", style: .cancel) { _ in completion?(false) }
    }
    postDetailViewController.present(alert, animated: true)
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
