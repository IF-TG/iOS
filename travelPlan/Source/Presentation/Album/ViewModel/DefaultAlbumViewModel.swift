//
//  DefaultAlbumViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 3/19/24.
//

import Foundation
import Combine
import Photos

struct AlbumViewModelInput {
  let viewDidLoad: PassthroughSubject<Void, Never> = .init()
  let didSelectPhoto: PassthroughSubject<IndexPath, Never> = .init()
  let touchedFirstQuadrant: PassthroughSubject<IndexPath, Never> = .init()
  let photoLibraryDidChange: PassthroughSubject<PHChange, Never> = .init()
  let viewWillAppear: PassthroughSubject<Void, Never> = .init()
}

enum AlbumViewModelState {
  case activateFinishButton(Bool)
  case reloadItem([IndexPath])
  case reloadData(isAuthLimited: Bool)
  case none
}

struct PhotoModel {
  let asset: PHAsset
  var selectedOrder: SelectionOrder
}

final class SelectedAlbumPhotoWrapper {
  @Published var indexArray = [Int]()
}

struct AlbumViewModelActions {
  let showDetailPhoto: (PhotoDetailModel, Int) -> Void
  let pop: () -> Void
  let popByPassingAssets: ([PHAsset]) -> Void
  let callSetting: () -> Void
  let presentLimitedLibraryPicker: () -> Void
}

final class DefaultAlbumViewModel {
  // MARK: - Dependencies
  private let albumUseCase: any AlbumUseCase
  private let actions: AlbumViewModelActions
  
  // MARK: - Properties
  private let selectedAlbumPhoto = SelectedAlbumPhotoWrapper()
  private var subscriptions = Set<AnyCancellable>()
  var dataSource = [PhotoModel]()
  
  private let parentPopPublisher: AnyPublisher<Void, Never>
  
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
    parentPopPublisher: AnyPublisher<Void, Never>,
    actions: AlbumViewModelActions
  ) {
    self.albumUseCase = albumUseCase
    self.parentPopPublisher = parentPopPublisher
    self.actions = actions
  }
}

// MARK: - AlbumViewModelable
extension DefaultAlbumViewModel: AlbumViewModelable {
  func transform(_ input: AlbumViewModelInput) -> AnyPublisher<AlbumViewModelState, Never> {
    return Publishers.MergeMany(
      viewWillAppearStream(input),
      viewDidLoadStream(input),
      touchedFirstQuadrantStream(input),
      selectedIndexArrayStream(input),
      photoLibraryDidChangeStream(input)
    )
    .eraseToAnyPublisher()
  }
}

// MARK: - Private Helpers
extension DefaultAlbumViewModel {
  private func viewWillAppearStream(_ input: Input) -> Output {
    input.viewWillAppear
      .flatMap { [weak self] in
        guard let self = self else { return Just(State.none).eraseToAnyPublisher() }
        return parentPopPublisher.map { [weak self] in
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
        }
        .eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
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
  
  private func selectedIndexArrayStream(_ input: Input) -> Output {
    return selectedAlbumPhoto.$indexArray
      .map { $0.count > 0 ? State.activateFinishButton(true) : State.activateFinishButton(false) }
      .eraseToAnyPublisher()
  }
  
  private func viewDidLoadStream(_ input: Input) -> Output {
    return input
      .viewDidLoad
      .map { [weak self] _ in
        guard let self = self else { return State.none }
        self.dataSource = self.albumUseCase
          .getAssets()
          .map { PhotoModel(asset: $0, selectedOrder: .none) }
        
        if #available(iOS 14, *) {
          return State.reloadData(isAuthLimited: self.isAuthStatusLimited)
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
          let selectMaxCountPolicy = self?.albumUseCase.maxSelectPhotoCount
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
}

// MARK: - AlbumViewModelPageDelegate
extension DefaultAlbumViewModel: AlbumViewModelPageDelegate {
  func showDetailPhoto(at itemIndex: Int) {
    let detailModel = PhotoDetailModel(
      photoModel: dataSource[itemIndex],
      selectedAlbumPhoto: selectedAlbumPhoto,
      indexPathItem: itemIndex
    )
    actions.showDetailPhoto(detailModel, albumUseCase.maxSelectPhotoCount)
  }
  
  func pop() {
    actions.pop()
  }
  
  func callSetting() {
    actions.callSetting()
  }
  
  func popByPassingAssets() {
    let selectedAssets = self.selectedAlbumPhoto.indexArray.map { indexPathItem in
      return self.dataSource[indexPathItem].asset
    }
    actions.popByPassingAssets(selectedAssets)
  }
  
  func presentLimitedLibraryPicker() {
    actions.presentLimitedLibraryPicker()
  }
}

// MARK: - AlbumViewModelDataSourceable
extension DefaultAlbumViewModel: AlbumViewModelDataSourceable {
  func numberOfItemsInSection() -> Int {
    return dataSource.count
  }
  
  func photoModel(ItemIndex: Int) -> PhotoModel {
    return dataSource[ItemIndex]
  }
}
