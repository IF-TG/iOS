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
}

final class PostDetailCoordinator: FlowCoordinator {
  var parent: FlowCoordinator?
  var child: [FlowCoordinator] = []
  var presenter: UINavigationController?
  
  /// dismiss호출코드에서 finish도 해줘야합니다
  private var postDetailViewController: PostDetailViewController
  
  init(presenter: UINavigationController?, post: Post, category: Post.Category) {
    self.presenter = presenter
    let mockPostRepository = MockPostRepository()
    let postUseCase = DefaultPostUseCase(postRepository: mockPostRepository)
    
    let mockPostCommentRepository = MockPostCommentRepository()
    let postCommentUseCase = DefaultPostCommentUseCase(postCommentRepository: mockPostCommentRepository)
    
    let postDetailVM = PostDetailViewModel(
      post: post,
      category: category,
      postUseCase: postUseCase,
      postCommentUseCase: postCommentUseCase)
    postDetailViewController = PostDetailViewController(viewModel: postDetailVM)
  }
  
  func start() {
    postDetailViewController.coordinator = self
    presenter?.pushViewController(postDetailViewController, animated: true)
  }
}

extension PostDetailCoordinator: PostDetailCoordinatorDelegate {
  func showAlertForError(with description: String, completion: (() -> Void)?) {
    let alert = UIAlertController(title: nil, message: description, preferredStyle: .alert).set {
      $0.addAction(UIAlertAction(title: "OK", style: .default) { _ in
        completion?()
      })
    }
    postDetailViewController.present(alert, animated: true)
  }
}
