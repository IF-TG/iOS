//
//  ReviewWritingCoordinator.swift
//  travelPlan
//
//  Created by SeokHyun on 11/4/23.
//

import UIKit
import SHCoordinator
import SHFirestoreService
import Photos
import Combine

/// Post를 전달받는 객체는 해당 프로토콜을 준수합니다.
protocol ReviewWritingPostReceivable: AnyObject {
  func receive(post: Post?)
}

protocol ReviewWritingCoordinatorDependencies {
  func makeReviewWritingViewController(
    mode: ReviewWritingMode,
    actions: ReviewWritingViewModelActions,
    selectedAssetsPublisher: AnyPublisher<[PHAsset], Never>,
    selectedCategoryPublisher: AnyPublisher<Post.Category?, Never>
  ) -> ReviewWritingViewController
  
  func makeAlbumCoordinator(presenter: UINavigationController?) -> AlbumCoordinator
}

final class ReviewWritingCoordinator: FlowCoordinator {
  // MARK: - Dependencies
  private let dependencies: any ReviewWritingCoordinatorDependencies
  
  // MARK: - Properties
  var parent: FlowCoordinator?
  var child: [FlowCoordinator] = []
  var presenter: UINavigationController?
  var viewController: UIViewController?
  private let mode: ReviewWritingMode
  private let selectedAssetsSubject = PassthroughSubject<[PHAsset], Never>()
  private let selectedCategorySubject = PassthroughSubject<Post.Category?, Never>()
  
  // MARK: - LifeCycle
  init(
    presenter: UINavigationController?,
    dependencies: any ReviewWritingCoordinatorDependencies,
    mode: ReviewWritingMode
  ) {
    self.presenter = presenter
    self.dependencies = dependencies
    self.mode = mode
  }
  
  deinit {
    print("deinit: \(Self.self)")
  }
}

// MARK: - Start
extension ReviewWritingCoordinator {
  func start(mode: ReviewWritingMode) {
    let actions = ReviewWritingViewModelActions(
      showAlbum: { [weak self] in self?.showAlbum() },
      showCategoryBottomSheet: { [weak self] in self?.showCategoryBottomSheet() },
      pop: { [weak self] in self?.pop() },
      popWith: { [weak self] post in self?.receive(post: post) },
      presentPlan: { [weak self] in self?.presentPlan() },
      alertAuthRequest: { [weak self] in self?.alertAuthRequest() }
    )
    
    let viewController = dependencies.makeReviewWritingViewController(
      mode: mode,
      actions: actions,
      selectedAssetsPublisher: selectedAssetsSubject.eraseToAnyPublisher(),
      selectedCategoryPublisher: selectedCategorySubject.eraseToAnyPublisher()
    )
    presenter?.pushViewController(viewController, animated: true)
  }
  
  func start() {}
}

// MARK: - Helpers
extension ReviewWritingCoordinator {
  func getSelectedAssets(_ selectedAssets: [PHAsset]) {
    self.selectedAssetsSubject.send(selectedAssets)
  }
}

// MARK: - Private Helpers
extension ReviewWritingCoordinator {
  private func showAlbum() {
    let childCoordinator = dependencies.makeAlbumCoordinator(presenter: presenter)
    addChild(with: childCoordinator)
  }
  
  private func showCategoryBottomSheet() {
    let bottomSheet = PostReviewWritingCategoryBottomSheet()
    bottomSheet.okButtonHandler = { [weak self] in
      self?.selectedCategorySubject.send(bottomSheet.selectedCategory)
    }
    presenter?.presentBottomSheet(bottomSheet)
  }
  
  private func pop() {
    finish(withAnimated: true)
  }
  
  private func presentPlan() {
    print("DEBUG: Plan을 present해야 합니다.")
  }
  
  private func alertAuthRequest() {
    print("DEBUG: alert화면을 띄워야 합니다.")
  }
}

// MARK: - ReviewWritingPostReceivable
extension ReviewWritingCoordinator: ReviewWritingPostReceivable {
  func receive(post: Post?) {
    guard let parent = parent as? ReviewWritingPostReceivable else { return }
    parent.receive(post: post)
    finish(withAnimated: true)
  }
}
