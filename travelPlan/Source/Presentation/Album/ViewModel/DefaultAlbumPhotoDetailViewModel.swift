//
//  DefaultAlbumPhotoDetailViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 4/3/24.
//

import Foundation
import Combine

struct PhotoDetailModel {
  var photoModel: PhotoModel
  let selectedAlbumPhoto: SelectedAlbumPhotoWrapper
  var indexPathItem: Int
}

struct AlbumPhotoDetailViewModelInput {
  let viewDidLoad: PassthroughSubject<Void, Never> = .init()
  let didTapOrderView: PassthroughSubject<Void, Never> = .init()
}

enum AlbumPhotoDetailViewModelState {
  case setOrder(Int)
  case cancelOrder
  case none
  case configureUI(PhotoModel)
}

struct AlbumPhotoDetailViewModelActions {
  let pop: () -> Void
}

final class DefaultAlbumPhotoDetailViewModel {
  // MARK: - Dependencies
  private var dataSource: PhotoDetailModel
  private let maxSelectPhotoCount: Int
  private let actions: AlbumPhotoDetailViewModelActions
  
  // MARK: - LifeCycle
  init(
    dataSource: PhotoDetailModel,
    maxSelectPhotoCount: Int,
    actions: AlbumPhotoDetailViewModelActions
  ) {
    self.dataSource = dataSource
    self.maxSelectPhotoCount = maxSelectPhotoCount
    self.actions = actions
  }
}

// MARK: - AlbumPhotoDetailViewModelable
extension DefaultAlbumPhotoDetailViewModel: AlbumPhotoDetailViewModelable {
  func transform(_ input: Input) -> Output {
    return Publishers.MergeMany(
      viewDidLoadStream(input),
      didTapOrderViewStream(input)
    )
    .eraseToAnyPublisher()
  }
}
 
// MARK: - Private Helpers
extension DefaultAlbumPhotoDetailViewModel {
  private func viewDidLoadStream(_ input: Input) -> Output {
    input.viewDidLoad
      .map { [weak self] in
        guard let photoDetailModel = self?.dataSource else { return .none }
        
        return State.configureUI(photoDetailModel.photoModel)
      }
      .eraseToAnyPublisher()
  }
  
  private func didTapOrderViewStream(_ input: Input) -> Output {
    input.didTapOrderView
      .map { [weak self] in
        guard 
          let selectedAlbumPhoto = self?.dataSource.selectedAlbumPhoto,
          let indexPathItem = self?.dataSource.indexPathItem
        else { return State.none }
         
        // selectedIndexArray에 indexPath가 있다면 제거
        if let index = selectedAlbumPhoto.indexArray.firstIndex(of: indexPathItem) {
          selectedAlbumPhoto.indexArray.remove(at: index)
          self?.dataSource.photoModel.selectedOrder = .none
          return State.cancelOrder
        } else { // 없다면
          guard let canSelectMaxCount = self?.maxSelectPhotoCount,
                let selectedPhotoCount = self?.dataSource.selectedAlbumPhoto.indexArray.count,
                canSelectMaxCount > selectedPhotoCount // maxCount 체크
          else { return State.none }
          
          selectedAlbumPhoto.indexArray.append(indexPathItem)
          self?.dataSource.photoModel.selectedOrder = .selected(selectedAlbumPhoto.indexArray.count)
          return State.setOrder(selectedAlbumPhoto.indexArray.count)
        }
      }
      .eraseToAnyPublisher()
  }
}

// MARK: - AlbumPhotoDetailViewModelPageDelegate
extension DefaultAlbumPhotoDetailViewModel: AlbumPhotoDetailViewModelPageDelegate {
  func pop() {
    actions.pop()
  }
}
