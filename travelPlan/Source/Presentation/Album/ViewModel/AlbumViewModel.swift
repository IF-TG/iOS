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
  let popAlbumPhotoDetailViewController: PassthroughSubject<Void, Never> = .init()
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
  case showDetailPhoto(PhotoDetailEntity)
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

class SelectedAlbumPhotoWrapper {
  @Published var indexArray = [Int]()
}

final class DefaultAlbumViewModel {
  
  // MARK: - Properties
  private let selectedAlbumPhoto = SelectedAlbumPhotoWrapper()
  private var subscriptions = Set<AnyCancellable>()
  private let albumUseCase: any AlbumUseCase
  private let photoAuthUseCase: any PhotoAuthorizationUseCase
  private let albumPhotoMaxCountUseCase: any AlbumPhotoMaxCountUseCase
  var dataSource = [PhotoModel]()
  
  private var isAuthStatusLimited: Bool {
    if #available(iOS 14, *) {
      PHPhotoLibrary.authorizationStatus(for: .readWrite) == .limited
    } else {
      false
    }
  }
  
  // MARK: - LifeCycle
  init(
    albumUseCase: any AlbumUseCase,
    photoAuthUseCase: any PhotoAuthorizationUseCase,
    albumPhotoMaxCountUseCase: any AlbumPhotoMaxCountUseCase
  ) {
    self.albumUseCase = albumUseCase
    self.photoAuthUseCase = photoAuthUseCase
    self.albumPhotoMaxCountUseCase = albumPhotoMaxCountUseCase
  }
}

// MARK: - AlbumViewModelable
extension DefaultAlbumViewModel: AlbumViewModelable {
  func transform(_ input: AlbumViewModelInput) -> AnyPublisher<AlbumViewModelState, Never> {
    return Publishers.MergeMany(
      viewDidLoadStream(input),
      popAlbumPhotoDetailViewControllerStream(input),
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
  private func popAlbumPhotoDetailViewControllerStream(_ input: Input) -> Output {
    return input
      .popAlbumPhotoDetailViewController
      .map { [weak self] in
        guard 
          let selectedAlbumPhoto = self?.selectedAlbumPhoto,
          let isAuthLimited = self?.isAuthStatusLimited,
          let count = self?.dataSource.count
        else { return State.none }
        
        for i in 0..<count {
          self?.dataSource[i].selectedOrder = .none
        }
        
        for (index, indexPathItem) in selectedAlbumPhoto.indexArray.enumerated() {
          self?.dataSource[indexPathItem].selectedOrder = .selected(index+1)
        }
        
        return State.reloadData(isAuthLimited: isAuthLimited)
      }.eraseToAnyPublisher()
  }
  
  private func photoLibraryDidChangeStream(_ input: Input) -> Output {
    return input
      .photoLibraryDidChange
      .filter { [weak self] _ in
        return self?.isAuthStatusLimited ?? false
      }
      .map { [weak self] changeInstance in
        guard let assets = self?.albumUseCase.getChangedAssets(changeInstance: changeInstance)
        else { return State.none }
        
        self?.selectedAlbumPhoto.indexArray.removeAll()
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
        let selectedAssets = self?.selectedAlbumPhoto.indexArray.map { indexPathItem in
          return self?.dataSource[indexPathItem].asset ?? .init()
        }
        return State.deliverAssetsToParents(selectedAssets ?? .init())
      }
      .eraseToAnyPublisher()
  }
  
  private func selectedIndexArrayStream(_ input: Input) -> Output {
    return selectedAlbumPhoto.$indexArray
      .map { $0.count > 0 ? State.activateFinishButton(true) : State.activateFinishButton(false) }
      .eraseToAnyPublisher()
  }
  
  private func viewDidLoadStream(_ input: Input) -> Output {
    return input
      .viewDidLoad
      .map { [weak self] _ in
        
        self?.dataSource = self?.albumUseCase
          .getAssets()
          .map { PhotoModel(asset: $0, selectedOrder: .none) } ?? .init()
        
        if #available(iOS 14, *) {
          return State.reloadData(isAuthLimited: self?.isAuthStatusLimited ?? true)
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
        guard
          let selectedAlbumPhotoCount = self?.selectedAlbumPhoto.indexArray.count,
          let selectMaxCountPolicy = self?.albumPhotoMaxCountUseCase.selectMaxCount
        else { return State.none }
          
        let updatingIndexPaths: [IndexPath]
        
        if case .selected = self?.dataSource[indexPath.item].selectedOrder { // 이미 선택이 되어있는 경우
          self?.dataSource[indexPath.item].selectedOrder = .none
          self?.selectedAlbumPhoto.indexArray.removeAll { $0 == indexPath.item }
          self?.selectedAlbumPhoto.indexArray.enumerated().forEach { index, indexPathItem in
            let order = index + 1
            let prev = self?.dataSource[indexPathItem]
            self?.dataSource[indexPathItem] = .init(
              asset: prev?.asset ?? .init(),
              selectedOrder: .selected(order)
            )
          }
          updatingIndexPaths = [indexPath] + (
            self?.selectedAlbumPhoto.indexArray
              .map { IndexPath(item: $0, section: .zero) } ?? .init()
          )
        } else { // 선택이 되어있지 않은 경우
          guard selectedAlbumPhotoCount < selectMaxCountPolicy
          else { return State.none }
          
          self?.selectedAlbumPhoto.indexArray.append(indexPath.item)
          self?.dataSource[indexPath.item].selectedOrder = .selected(
            self?.selectedAlbumPhoto.indexArray.count ?? .zero
          )
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
        guard 
          let photoModel = self?.dataSource[indexPath.item],
          let selectedAlbumPhoto = self?.selectedAlbumPhoto
        else { return State.none }
        
        let photoDetailEntity = PhotoDetailEntity(
          photoModel: photoModel,
          selectedAlbumPhoto: selectedAlbumPhoto,
          indexPathItem: indexPath.item
        )
        
        return State.showDetailPhoto(photoDetailEntity)
      }
      .eraseToAnyPublisher()
  }
}

struct PhotoDetailEntity {
  var photoModel: PhotoModel
  let selectedAlbumPhoto: SelectedAlbumPhotoWrapper
  var indexPathItem: Int
}
