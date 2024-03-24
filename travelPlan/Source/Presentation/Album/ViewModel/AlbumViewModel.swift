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
}

enum AlbumViewModelState {
  case activateFinishButton(Bool)
  case showDetailPhoto(PHAsset)
  case reloadItem([IndexPath])
  case reloadData
  case none
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
  private var selectedPhotoItems = [Int]()
  var albums = [PHFetchResult<PHAsset>]()
  var dataSource = [PhotoModel]()
  
  // MARK: - LifeCycle
  init(albumUseCase: AlbumUseCase) {
    self.albumUseCase = albumUseCase
  }
}

// MARK: - AlbumViewModelable
extension DefaultAlbumViewModel: AlbumViewModelable {
  func transform(_ input: AlbumViewModelInput) -> AnyPublisher<AlbumViewModelState, Never> {
    return Publishers.MergeMany(
      viewDidLoadStream(input),
      touchedFirstQuadrantStream(input),
      touchedElseQuadrantStream(input),
      selectedIndexArrayStream(input)
    )
    .eraseToAnyPublisher()
  }
}

// MARK: - Private Helpers
extension DefaultAlbumViewModel {
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
        
        return .reloadData
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
