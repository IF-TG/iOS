//
//  AlbumPhotoDetailCoordinator.swift
//  travelPlan
//
//  Created by SeokHyun on 4/3/24.
//

import SHCoordinator
import UIKit
import Photos

protocol AlbumPhotoDetailCoordinatorDelegate: FlowCoordinatorDelegate {
  
}

final class AlbumPhotoDetailCoordinator: FlowCoordinator {
  
  // MARK: - Properties
  var parent: FlowCoordinator?
  var child: [FlowCoordinator] = []
  var presenter: UINavigationController?
  private let asset: PHAsset
  
  // MARK: - LifeCycle
  init(presenter: UINavigationController?, asset: PHAsset) {
    self.presenter = presenter
    self.asset = asset
  }
  
  func start() {
    let albumPhotoDetailViewModel = DefaultAlbumPhotoDetailViewModel()
    let photoService = DefaultPhotoService()
    let albumPhotoDetailViewController = AlbumPhotoDetailViewController(
      viewModel: albumPhotoDetailViewModel,
      photoService: photoService,
      asset: asset
    )
    albumPhotoDetailViewController.coordinator = self
    presenter?.pushViewController(albumPhotoDetailViewController, animated: true)
  }
}

// MARK: - AlbumPhotoDetailCoordinatorDelegate
extension AlbumPhotoDetailCoordinator: AlbumPhotoDetailCoordinatorDelegate {
  
}
