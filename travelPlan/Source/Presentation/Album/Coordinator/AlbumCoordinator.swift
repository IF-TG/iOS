//
//  AlbumCoordinator.swift
//  travelPlan
//
//  Created by SeokHyun on 1/14/24.
//

import UIKit
import SHCoordinator
import PhotosUI
import Combine

protocol AlbumCoordinatorDependencies {
  func makeAlbumViewController(
    parentPopPublisher: AnyPublisher<Void, Never>,
    actions: AlbumViewModelActions
  ) -> AlbumViewController
  
  func makeAlbumPhotoDetailCoordinator(
    presenter: UINavigationController?
  ) -> AlbumPhotoDetailCoordinator
}

final class AlbumCoordinator: FlowCoordinator {
  // MARK: - Dependencies
  private let dependencies: any AlbumCoordinatorDependencies
  
  // MARK: - Properties
  var parent: FlowCoordinator?
  var child: [FlowCoordinator] = []
  var presenter: UINavigationController?
  private weak var viewController: UIViewController?
  private let parentPopSubject = PassthroughSubject<Void, Never>()
  
  // MARK: - LifeCycle
  init(presenter: UINavigationController?, dependencies: any AlbumCoordinatorDependencies) {
    self.presenter = presenter
    self.dependencies = dependencies
  }
  
  deinit {
    print("deinit: \(AlbumCoordinator.self)")
  }
  
  // MARK: - Helpers
  func start() {
    let actions = AlbumViewModelActions(
      showDetailPhoto: { [weak self] detailModel, maxSelectPhotoCount in
        self?.showPhotoDetail(photoDetailModel: detailModel, maxSelectPhotoCount: maxSelectPhotoCount)
      },
      pop: { [weak self] in
        self?.finish(withAnimated: true)
      },
      popByPassingAssets: { [weak self] selectedAssets in
        self?.finish(selectedAssets: selectedAssets)
      },
      callSetting: { [weak self] in
        self?.openSettings()
      },
      presentLimitedLibraryPicker: { [weak self] in
        if #available(iOS 14, *) {
          self?.presentLimitedLibraryPicker()
        }
      }
    )
    
    let albumViewController = dependencies.makeAlbumViewController(
      parentPopPublisher: self.parentPopSubject.eraseToAnyPublisher(),
      actions: actions
    )
    self.viewController = albumViewController
    presenter?.pushViewController(albumViewController, animated: true)
  }
}

// MARK: - Private Helpers
extension AlbumCoordinator {
  private func showPhotoDetail(photoDetailModel: PhotoDetailModel, maxSelectPhotoCount: Int) {
    let childCoordinator = dependencies.makeAlbumPhotoDetailCoordinator(presenter: presenter)
    child.append(childCoordinator)
    childCoordinator.parent = self
    childCoordinator.start(
      photoDetailModel: photoDetailModel,
      maxSelectPhotoCount: maxSelectPhotoCount
    )
  }
  
  private func openSettings() {
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
  private func presentLimitedLibraryPicker() {
    guard let viewController = self.viewController else { return }
    PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: viewController)
  }
  
  private func finish(selectedAssets: [PHAsset]) {
    guard let parent = parent as? ReviewWritingCoordinator else { return }
    
    parent.getSelectedAssets(selectedAssets)
    finish(withAnimated: true)
  }
}

// MARK: - AlbumCoordinatorDelegate
extension AlbumCoordinator: AlbumCoordinatorDelegate {
  func reloadDataByAlbumPhotoDetail() {
    parentPopSubject.send()
  }
}
