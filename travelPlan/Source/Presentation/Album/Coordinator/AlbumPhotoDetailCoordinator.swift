//
//  AlbumPhotoDetailCoordinator.swift
//  travelPlan
//
//  Created by SeokHyun on 4/3/24.
//

import SHCoordinator
import UIKit
import Photos

protocol AlbumPhotoDetailCoordinatorDependencies {
  func makeAlbumPhotoDetailViewController(
    photoDetailModel: PhotoDetailModel,
    maxSelectPhotoCount: Int,
    actions: AlbumPhotoDetailViewModelActions
  ) -> AlbumPhotoDetailViewController
}

final class AlbumPhotoDetailCoordinator: FlowCoordinator {
  // MARK: - Dependencies
  private let dependencies: any AlbumPhotoDetailCoordinatorDependencies
  
  // MARK: - Properties
  var parent: FlowCoordinator?
  var child: [FlowCoordinator] = []
  var presenter: UINavigationController?
  
  // MARK: - LifeCycle
  init(
    presenter: UINavigationController?,
    dependencies: any AlbumPhotoDetailCoordinatorDependencies
  ) {
    self.presenter = presenter
    self.dependencies = dependencies
  }
  
  // MARK: - Start
  func start(photoDetailModel: PhotoDetailModel, maxSelectPhotoCount: Int) {
    let actions = AlbumPhotoDetailViewModelActions(pop: { [weak self] in
      self?.pop()
    })
    
    let viewController = dependencies.makeAlbumPhotoDetailViewController(
      photoDetailModel: photoDetailModel,
      maxSelectPhotoCount: maxSelectPhotoCount,
      actions: actions
    )
    presenter?.pushViewController(viewController, animated: true)
  }
  
  func start() { }
}

// MARK: - Private Helpers
extension AlbumPhotoDetailCoordinator {
  private func pop() {
    guard let parent = parent as? AlbumCoordinatorDelegate else { return }
    
    parent.reloadDataByAlbumPhotoDetail()
    self.finish(withAnimated: true)
  }
}
