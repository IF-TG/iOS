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
    bottomSheet.dismissHandler = { [weak self] in
      // TODO: - 추가로직 정하기
      // dismiss후 여행 후기 작성 화면으로 돌아간 로딩 화면과 함께 서버 전송 후 피드로 갈것인지
      // 바텀시트 시점에서 서버 전송 후 뒤로가기 두 번 할 것인지
      // 뭔가,, 리뷰작성으로 돌아간 후에 인디케이터 -> 완료되면 완료되었습니다! 알림창 0.7초후 -> 뒤로가는 것도 좋을 것 같습니다.
      print(bottomSheet.selectedCategory)
      if bottomSheet.hasSelectedAtLeastOneTheme {
        self?.finish(withAnimated: true)
      }
    }
    presenter?.presentBottomSheet(bottomSheet)
  }
}
