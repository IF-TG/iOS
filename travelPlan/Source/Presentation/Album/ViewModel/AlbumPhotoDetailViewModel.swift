//
//  AlbumPhotoDetailViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 4/3/24.
//

import Foundation
import Combine

protocol AlbumPhotoDetailViewModelable: ViewModelable
where Input == AlbumPhotoDetailViewModelInput,
      State == AlbumPhotoDetailViewModelState,
      Output == AnyPublisher<State, Never> { }

struct AlbumPhotoDetailViewModelInput {
  let viewDidLoad: PassthroughSubject<Void, Never> = .init()
  let didTapOrderView: PassthroughSubject<Void, Never> = .init()
  let didTapBackButton: PassthroughSubject<Void, Never> = .init()
}

enum AlbumPhotoDetailViewModelState {
  case popViewController
  case setOrder(Int)
  case cancelOrder
  case none
  case configureUI(PhotoModel)
}

final class DefaultAlbumPhotoDetailViewModel {
  // MARK: - Properties
  private var photoDetailEntity: PhotoDetailEntity
  private let albumPhotoMaxCountUseCase: any AlbumPhotoMaxCountUseCase
  
  // MARK: - LifeCycle
  init(photoDetailEntity: PhotoDetailEntity, albumPhotoMaxCountUseCase: any AlbumPhotoMaxCountUseCase) {
    self.photoDetailEntity = photoDetailEntity
    self.albumPhotoMaxCountUseCase = albumPhotoMaxCountUseCase
  }
}

// MARK: - AlbumPhotoDetailViewModelable
extension DefaultAlbumPhotoDetailViewModel: AlbumPhotoDetailViewModelable {
  func transform(_ input: Input) -> Output {
    return Publishers.MergeMany(
      viewDidLoadStream(input),
      didTapOrderViewStream(input),
      didTapBackButtonStream(input)
    )
    .eraseToAnyPublisher()
  }
}
 
// MARK: - Private Helpers
extension DefaultAlbumPhotoDetailViewModel {
  private func viewDidLoadStream(_ input: Input) -> Output {
    input.viewDidLoad
      .map { [weak self] in
        guard let photoDetailEntity = self?.photoDetailEntity else { return .none }
        
        return State.configureUI(photoDetailEntity.photoModel)
      }
      .eraseToAnyPublisher()
  }
  
  private func didTapBackButtonStream(_ input: Input) -> Output {
    input.didTapBackButton
      .map {
        return State.popViewController
      }
      .eraseToAnyPublisher()
  }
  
  private func didTapOrderViewStream(_ input: Input) -> Output {
    input.didTapOrderView
      .map { [weak self] in
        guard 
          let selectedAlbumPhoto = self?.photoDetailEntity.selectedAlbumPhoto,
          let indexPathItem = self?.photoDetailEntity.indexPathItem
        else { return State.none }
         
        // selectedIndexArray에 indexPath가 있다면 제거
        if let index = selectedAlbumPhoto.indexArray.firstIndex(of: indexPathItem) {
          selectedAlbumPhoto.indexArray.remove(at: index)
          self?.photoDetailEntity.photoModel.selectedOrder = .none
          return State.cancelOrder
        } else { // 없다면
          guard let selectMaxCountPolicy = self?.albumPhotoMaxCountUseCase.selectMaxCount,
                let selectedPhotoCount = self?.photoDetailEntity.selectedAlbumPhoto.indexArray.count,
                selectMaxCountPolicy > selectedPhotoCount // maxCount 체크
          else { return State.none }
          selectedAlbumPhoto.indexArray.append(indexPathItem)
          self?.photoDetailEntity.photoModel.selectedOrder = .selected(selectedAlbumPhoto.indexArray.count)
          return State.setOrder(selectedAlbumPhoto.indexArray.count)
        }
      }
      .eraseToAnyPublisher()
  }
}
