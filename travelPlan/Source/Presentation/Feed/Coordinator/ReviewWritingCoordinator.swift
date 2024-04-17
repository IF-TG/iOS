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

/// Post를 전달받는 객체는 해당 프로토콜을 준수합니다.
protocol ReviewWritingPostReceivable: AnyObject {
  func receive(post: Post)
}

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
    let mockSession = MockSession.default
    let sessionProvider = SessionProvider(session: mockSession)
    let reviewWritingRepository = DefaultReviewWritingRepository(service: sessionProvider)
    let reviewWritingUseCase = DefaultReviewWritingUseCase(reviewWritingRepository: reviewWritingRepository)
    let photoAuthUseCase = DefaultPhotoAuthorizationUseCase()
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
  
  func showCategoryBottomSheet() {
    let bottomSheet = PostReviewWritingCategoryBottomSheet()
    bottomSheet.dismissHandler = {
      /// 내부 클로저에 self타입의 프로퍼티, 함수를 쓸 경우 반드시 [weak self] 사용해야 합니다: )
      print(bottomSheet.selectedCategory)
    }
    presenter?.presentBottomSheet(bottomSheet)
  }
}

// MARK: - ReviewWritingPostReceivable
extension ReviewWritingCoordinator: ReviewWritingPostReceivable {
  func receive(post: Post) {
    guard let parent = parent as? ReviewWritingPostReceivable else { return }
    parent.receive(post: post)
    finish(withAnimated: true)
  }
}
