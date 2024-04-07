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
  func popViewController()
}

final class AlbumPhotoDetailCoordinator: FlowCoordinator {
  
  // MARK: - Properties
  var parent: FlowCoordinator?
  var child: [FlowCoordinator] = []
  var presenter: UINavigationController?
  private let photoDetailEntity: PhotoDetailEntity
  
  // MARK: - LifeCycle
  init(presenter: UINavigationController?, photoDetailEntity: PhotoDetailEntity) {
    self.presenter = presenter
    self.photoDetailEntity = photoDetailEntity
  }
  
  func start() {
    let albumPhotoMaxCountUseCase = DefaultAlbumPhotoMaxCountUseCase()
    let albumPhotoDetailViewModel = DefaultAlbumPhotoDetailViewModel(
      photoDetailEntity: photoDetailEntity,
      albumPhotoMaxCountUseCase: albumPhotoMaxCountUseCase
    )
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
  func popViewController() {
    guard let parent = parent as? AlbumCoordinator else { return }
    
    parent.popAlbumPhotoDetailViewController()
    self.finish(withAnimated: true)
  }
}
