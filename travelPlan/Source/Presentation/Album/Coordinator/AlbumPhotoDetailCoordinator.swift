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
  private let photoDetailModel: PhotoDetailModel
  
  // MARK: - LifeCycle
  init(presenter: UINavigationController?, photoDetailModel: PhotoDetailModel) {
    self.presenter = presenter
    self.photoDetailModel = photoDetailModel
  }
  
  func start() {
    let albumPhotoMaxCountUseCase = DefaultAlbumPhotoMaxCountUseCase()
    let albumPhotoDetailViewModel = DefaultAlbumPhotoDetailViewModel(
      photoDetailModel: photoDetailModel,
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
