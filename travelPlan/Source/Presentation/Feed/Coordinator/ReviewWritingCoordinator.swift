//
//  ReviewWritingCoordinator.swift
//  travelPlan
//
//  Created by SeokHyun on 11/4/23.
//

import UIKit
import SHCoordinator
import Photos
import Combine

protocol ReviewWritingCoordinatorDelegate: FlowCoordinatorDelegate {
  var selectedAssetsPublisher: AnyPublisher<[PHAsset], Never> { get }
  
  func showPhotoViewController()
}

final class ReviewWritingCoordinator: FlowCoordinator {
  
  // MARK: - Properties
  var parent: FlowCoordinator?
  var child: [FlowCoordinator] = []
  var presenter: UINavigationController?
  var viewController: UIViewController?
  private let mode: ReviewWritingMode
  @Published private var selectedAssets = [PHAsset]()
  
  // MARK: - LifeCycle
  init(presenter: UINavigationController?, mode: ReviewWritingMode) {
    self.presenter = presenter
    self.mode = mode
  }
  
  deinit {
    print("deinit: \(Self.self)")
  }
  
  func start() {
    let photoAuthUseCase = DefaultPhotoAuthorizationUseCase()
    let reviewWritingRepository = DefaultReviewWritingRepository()
    let reviewWritingUseCase = DefaultReviewWritingUseCase(reviewWritingRepository: reviewWritingRepository)
    let viewModel = DefaultReviewWritingViewModel(
      photoAuthorizationUseCase: photoAuthUseCase,
      reviewWritingUseCase: reviewWritingUseCase,
      mode: mode
    )
    let photoService = DefaultPhotoService()
    let vc = ReviewWritingViewController(viewModel: viewModel, photoService: photoService)
    vc.coordinator = self
    presenter?.pushViewController(vc, animated: true)
  }
}

// MARK: - Helpers
extension ReviewWritingCoordinator {
  func getSelectedAssets(_ selectedAssets: [PHAsset]) {
    self.selectedAssets = selectedAssets
  }
}

extension ReviewWritingCoordinator: ReviewWritingCoordinatorDelegate {
  var selectedAssetsPublisher: AnyPublisher<[PHAsset], Never> {
    self.$selectedAssets.eraseToAnyPublisher()
  }
  
  func showPhotoViewController() {
    let childCoordinator = AlbumCoordinator(presenter: presenter)
    addChild(with: childCoordinator)
  }
}
