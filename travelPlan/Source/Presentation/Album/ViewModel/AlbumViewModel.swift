//
//  AlbumViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 3/19/24.
//

import Foundation
import Combine
import Photos

protocol AlbumDataSourceable {
  var dataSource: [PhotoModel] { get }
}

protocol AlbumViewModelable: ViewModelable, AlbumDataSourceable
where AlbumViewModelInput == Input,
      AlbumViewModelState == State,
      AnyPublisher<State, Never> == Output { }

struct AlbumViewModelInput {
  let viewDidLoad: PassthroughSubject<Void, Never> = .init()
  let didSelectPhoto: PassthroughSubject<IndexPath, Never> = .init()
  let touchedFirstQuadrant: PassthroughSubject<IndexPath, Never> = .init()
  let touchedElseQuadrant: PassthroughSubject<IndexPath, Never> = .init()
  let didTapCancelButton: PassthroughSubject<Void, Never> = .init()
  let didTapFinishButton: PassthroughSubject<Void, Never> = .init()
  let didTapSelectMorePhotosButton: PassthroughSubject<Void, Never> = .init()
  let didTapAuthsettingButton: PassthroughSubject<Void, Never> = .init()
  let photoLibraryDidChange: PassthroughSubject<PHChange, Never> = .init()
}

enum AlbumViewModelState {
  case activateFinishButton(Bool)
  case showDetailPhoto(PHAsset)
  case reloadItem([IndexPath])
  case reloadData(isAuthLimited: Bool)
  case none
  case popViewController
  case deliverAssetsToParents([PHAsset])
  case callSetting
  case presentLimitedLibraryPicker
}

struct PhotoModel {
  let asset: PHAsset
  var selectedOrder: SelectionOrder
}

final class DefaultAlbumViewModel {
  
  // MARK: - Properties
  @Published private var selectedIndexArray = [Int]()
  private var subscriptions = Set<AnyCancellable>()
  private let albumUseCase: AlbumUseCase
  private let photoAuthUseCase: PhotoAuthorizationUseCase
  private var selectedPhotoItems = [Int]()
  var albums = [PHFetchResult<PHAsset>]()
  var dataSource = [PhotoModel]()
  private var isAuthStatusLimited: Bool {
    if #available(iOS 14, *) {
      PHPhotoLibrary.authorizationStatus(for: .readWrite) == .limited
    } else {
      false
    }
  }
  
  // MARK: - LifeCycle
  init(albumUseCase: AlbumUseCase, photoAuthUseCase: PhotoAuthorizationUseCase) {
    self.albumUseCase = albumUseCase
    self.photoAuthUseCase = photoAuthUseCase
  }
}

// MARK: - AlbumViewModelable
extension DefaultAlbumViewModel: AlbumViewModelable {
  func transform(_ input: AlbumViewModelInput) -> AnyPublisher<AlbumViewModelState, Never> {
    return Publishers.MergeMany(
      viewDidLoadStream(input),
      touchedFirstQuadrantStream(input),
      touchedElseQuadrantStream(input),
      selectedIndexArrayStream(input),
      didTapFinishButtonStream(input),
      didTapCancelButtonStream(input),
      didTapSelectMorePhotosButtonStream(input),
      didTapAuthsettingButtonStream(input),
      photoLibraryDidChangeStream(input)
    )
    .eraseToAnyPublisher()
  }
}

// MARK: - Private Helpers
extension DefaultAlbumViewModel {
  private func photoLibraryDidChangeStream(_ input: Input) -> Output {
    return input
      .photoLibraryDidChange
      .filter { [weak self] _ in
        guard let self else { return false }
        return self.isAuthStatusLimited
      }
      .map { [weak self] changeInstance in
        guard let assets = self?.albumUseCase.getChangedAssets(changeInstance: changeInstance)
        else { return State.none }
        
        self?.selectedIndexArray.removeAll()
        self?.dataSource = assets.map { PhotoModel(asset: $0, selectedOrder: .none) }
    
        return State.reloadData(isAuthLimited: self?.isAuthStatusLimited ?? true)
      }
      .eraseToAnyPublisher()
  }
  
  private func didTapSelectMorePhotosButtonStream(_ input: Input) -> Output {
    return input
      .didTapSelectMorePhotosButton
      .map {
        return State.presentLimitedLibraryPicker
      }
      .eraseToAnyPublisher()
  }
  
  private func didTapAuthsettingButtonStream(_ input: Input) -> Output {
    return input
      .didTapAuthsettingButton
      .receive(on: RunLoop.main)
      .map {
        return State.callSetting
      }
      .eraseToAnyPublisher()
  }
  
  private func didTapCancelButtonStream(_ input: Input) -> Output {
    return input
      .didTapCancelButton
      .receive(on: RunLoop.main)
      .map { State.popViewController }
      .eraseToAnyPublisher()
  }
  
  private func didTapFinishButtonStream(_ input: Input) -> Output {
    return input
      .didTapFinishButton
      .map { [weak self] in
        guard let self else { return State.none }
        
        let selectedAssets = self.selectedIndexArray.map { indexPathItem in
          return self.dataSource[indexPathItem].asset
        }
        return State.deliverAssetsToParents(selectedAssets)
      }
      .eraseToAnyPublisher()
  }
  
  private func selectedIndexArrayStream(_ input: Input) -> Output {
    return $selectedIndexArray
      .map { $0.count > 0 ? State.activateFinishButton(true) : State.activateFinishButton(false) }
      .eraseToAnyPublisher()
  }
  
  private func viewDidLoadStream(_ input: Input) -> Output {
    return input
      .viewDidLoad
      .map { [weak self] _ in
        guard let self else { return State.none }
        
        self.dataSource = self.albumUseCase
          .getAssets()
          .map { PhotoModel(asset: $0, selectedOrder: .none) }
        
        if #available(iOS 14, *) {
          return State.reloadData(isAuthLimited: isAuthStatusLimited)
        } else {
          return State.reloadData(isAuthLimited: false)
        }
      }
      .eraseToAnyPublisher()
  }
  
  private func touchedFirstQuadrantStream(_ input: Input) -> Output {
    return input
      .touchedFirstQuadrant
      .map { [weak self] indexPath in
        guard let self else { return .none }
        
        let updatingIndexPaths: [IndexPath]
        
        if case .selected = self.dataSource[indexPath.item].selectedOrder {
          dataSource[indexPath.item].selectedOrder = .none
          self.selectedIndexArray.removeAll { $0 == indexPath.item }
          self.selectedIndexArray.enumerated().forEach { index, indexPathItem in
            let order = index + 1
            let prev = self.dataSource[indexPathItem]
            self.dataSource[indexPathItem] = .init(asset: prev.asset, selectedOrder: .selected(order))
          }
          updatingIndexPaths = [indexPath] + selectedIndexArray.map { IndexPath(item: $0, section: .zero) }
        } else {
          guard selectedIndexArray.count < albumUseCase.maxSelectedImageCount
          else { return State.none }
          
          self.selectedIndexArray.append(indexPath.item)
          self.dataSource[indexPath.item].selectedOrder = .selected(self.selectedIndexArray.count)
          updatingIndexPaths = [indexPath]
        }
        return State.reloadItem(updatingIndexPaths)
      }
      .eraseToAnyPublisher()
  }
  
  private func touchedElseQuadrantStream(_ input: Input) -> Output {
    return input
      .touchedElseQuadrant
      .map { [weak self] indexPath in
        guard let self else { return State .none }
        return State.showDetailPhoto(self.dataSource[indexPath.item].asset)
      }
      .eraseToAnyPublisher()
  }
}
