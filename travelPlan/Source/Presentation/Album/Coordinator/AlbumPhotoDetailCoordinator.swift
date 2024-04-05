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
  private let photoModel: PhotoModel
  
  // MARK: - LifeCycle
  init(presenter: UINavigationController?, photoModel: PhotoModel) {
    self.presenter = presenter
    self.photoModel = photoModel
  }
  
  func start() {
    let albumPhotoDetailViewModel = DefaultAlbumPhotoDetailViewModel(photoModel: photoModel)
    let photoService = DefaultPhotoService()
    let albumPhotoDetailViewController = AlbumPhotoDetailViewController(
      viewModel: albumPhotoDetailViewModel,
      photoService: photoService
    )
    albumPhotoDetailViewController.coordinator = self
    presenter?.pushViewController(albumPhotoDetailViewController, animated: true)
  }
}

// MARK: - AlbumPhotoDetailCoordinatorDelegate
extension AlbumPhotoDetailCoordinator: AlbumPhotoDetailCoordinatorDelegate {
  
}
