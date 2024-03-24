//
//  AlbumCoordinator.swift
//  travelPlan
//
//  Created by SeokHyun on 1/14/24.
//

import UIKit
import SHCoordinator

final class AlbumCoordinator: FlowCoordinator {
  // MARK: - Properties
  var parent: FlowCoordinator?
  var child: [FlowCoordinator] = []
  var presenter: UINavigationController?
  
  // MARK: - LifeCycle
  init(presenter: UINavigationController?) {
    self.presenter = presenter
  }
  
  deinit {
    print("deinit: \(AlbumCoordinator.self)")
  }
  
  // MARK: - Helpers
  func start() {
    guard let reviewWritingVC = presenter?.viewControllers.last as? ReviewWritingViewController else { return }
    let albumUsecase = DefaultAlbumUseCase()
    let viewModel = DefaultAlbumViewModel(albumUseCase: albumUsecase)
    let viewController = AlbumViewController(viewModel: viewModel, photoService: DefaultPhotoService())
    viewController.imageCompletionHandler = { images in
      reviewWritingVC.setImageView(to: images)
    }
    presenter?.delegate = viewController
    // TODO: - viewModel 추가하기
    viewController.coordinator = self
    presenter?.pushViewController(viewController, animated: true)
  }
}
