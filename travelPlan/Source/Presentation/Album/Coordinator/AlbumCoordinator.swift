//
//  AlbumCoordinator.swift
//  travelPlan
//
//  Created by SeokHyun on 1/14/24.
//

import UIKit
import SHCoordinator
import PhotosUI

protocol AlbumCoordinatorDelegate: AnyObject, FlowCoordinatorDelegate {
  func openSettings()
  func finish(selectedAssets: [PHAsset])
  func showPhotoDetail(photoModel: PhotoModel)
  
  @available(iOS 14, *)
  func presentLimitedLibraryPicker(controller: UIViewController)
}

final class AlbumCoordinator: FlowCoordinator {
  // MARK: - Properties
  var parent: FlowCoordinator?
  var child: [FlowCoordinator] = []
  var presenter: UINavigationController?
  private var viewController: AlbumViewController?
  
  // MARK: - LifeCycle
  init(presenter: UINavigationController?) {
    self.presenter = presenter
  }
  
  deinit {
    print("deinit: \(AlbumCoordinator.self)")
  }
  
  // MARK: - Helpers
  func start() {
    let albumUsecase = DefaultAlbumUseCase()
    let photoAuthUseCase = DefaultPhotoAuthorizationUseCase()
    let viewModel = DefaultAlbumViewModel(albumUseCase: albumUsecase, photoAuthUseCase: photoAuthUseCase)
    let photoService = DefaultPhotoService()
    let albumViewController = AlbumViewController(viewModel: viewModel, photoService: photoService)
    viewController = albumViewController
    presenter?.delegate = albumViewController
    albumViewController.coordinator = self
    
    presenter?.pushViewController(albumViewController, animated: true)
  }
}

// MARK: - AlbumCoordinatorDelegate
extension AlbumCoordinator: AlbumCoordinatorDelegate, FlowCoordinatorDelegate {
  func showPhotoDetail(photoModel: PhotoModel) {
    let childCoordinator = AlbumPhotoDetailCoordinator(presenter: presenter, photoModel: photoModel)
    addChild(with: childCoordinator)
  }
  
  func openSettings() {
    guard
      let url = URL(string: UIApplication.openSettingsURLString),
      UIApplication.shared.canOpenURL(url)
    else { return }
    
    UIApplication.shared.open(url, completionHandler: { success in
      // TODO: - 이때 앱으로 다시 들어가면 앱이 처음부터 다시켜지기 때문에, 마지막으로 썼던 글들을 자동 저장해야합니다.
      print("finished")
    })
  }
  
  @available(iOS 14, *)
  func presentLimitedLibraryPicker(controller: UIViewController) {
    PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: controller)
  }
  
  func finish(selectedAssets: [PHAsset]) {
    guard parent != nil, let parent = parent as? ReviewWritingCoordinator else { return }
    
    parent.getSelectedAssets(selectedAssets)
    finish(withAnimated: true)
  }
}
