//
//  FeedPostCoordinator.swift
//  travelPlan
//
//  Created by 양승현 on 3/22/24.
//

import UIKit
import SHCoordinator

protocol FeedPostCoordinatorDelegate: FlowCoordinatorDelegate { }

final class FeedPostCoordinator: FlowCoordinator {
  // MARK: - Properties
  var parent: FlowCoordinator?
  var child: [FlowCoordinator] = []
  var presenter: UINavigationController?
  private weak var feedPostViewController: FeedPostViewController?
  private let category: PostCategory
  
  init(presenter: UINavigationController, feedCategory: PostCategory) {
    self.presenter = presenter
    self.category = feedCategory
  }
  
  func start() {
//    mockPostRepository의 경우 mock_response_postContainer.swift 파일에 3개의 포스트밖에 없어서
//    페이징을 할 수 없습니다.
//    let mockPostRepository = MockPostRepository()
//    let defaultPostUseCase = DefaultPostUseCase(postRepository: mockPostRepository)
    let mockPostUseCase = MockPostUseCaseForPaging()
    let viewModel = FeedPostViewModel(
      postCategory: category,
      postUseCase: mockPostUseCase)
    let feedPostViewController = FeedPostViewController(
      type: category, viewModel: viewModel)
    self.feedPostViewController = feedPostViewController
    feedPostViewController.coordinator = self
    presenter?.pushViewController(feedPostViewController, animated: true)
  }
}

extension FeedPostCoordinator: FeedPostCoordinatorDelegate {
  
}
