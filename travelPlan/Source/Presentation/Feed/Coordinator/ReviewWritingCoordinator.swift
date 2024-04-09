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
  func showCategoryBottomSheet()
}

final class ReviewWritingCoordinator: FlowCoordinator {
  
  // MARK: - Properties
  var parent: FlowCoordinator?
  var child: [FlowCoordinator] = []
  var presenter: UINavigationController?
  var viewController: UIViewController?
  @Published private var selectedAssets = [PHAsset]()
  
  // MARK: - LifeCycle
  init(presenter: UINavigationController?) {
    self.presenter = presenter
  }
  
  deinit {
    print("deinit: \(Self.self)")
  }
  
  func start() {
    let photoAuthUseCase = DefaultPhotoAuthorizationUseCase()
    let viewModel = DefaultReviewWritingViewModel(photoAuthorizationUseCase: photoAuthUseCase)
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
  
  func showCategoryBottomSheet() {
    let bottomSheet = PostReviewWritingCategoryBottomSheet()
    bottomSheet.dismissHandler = {
      /// 내부 클로저에 self타입의 프로퍼티, 함수를 쓸 경우 반드시 [weak self] 사용해야 합니다: )
      print(bottomSheet.selectedCategory)
    }
    presenter?.presentBottomSheet(bottomSheet)
  }
}
