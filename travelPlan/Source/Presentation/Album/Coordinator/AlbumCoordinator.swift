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
    guard let reviewWritingViewController = presenter?.viewControllers.last 
            as? ReviewWritingViewController else { return }
    let albumUsecase = DefaultAlbumUseCase()
    let viewModel = DefaultAlbumViewModel(albumUseCase: albumUsecase)
    let photoService = DefaultPhotoService()
    let albumViewController = AlbumViewController(viewModel: viewModel, photoService: photoService)
    albumViewController.finishButtonHandler = { assets in
      reviewWritingViewController.setupImage(assets: assets, photoService: photoService)
    }
    presenter?.delegate = albumViewController
    albumViewController.coordinator = self
    presenter?.pushViewController(albumViewController, animated: true)
  }
}
