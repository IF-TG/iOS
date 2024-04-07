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
//  private var selectedCount: Int
  
//  private var selectedIndexArray = [Int]()
//  private var indexPathItem = 0
  
  // MARK: - LifeCycle
  init(photoDetailEntity: PhotoDetailEntity) {
    self.photoDetailEntity = photoDetailEntity
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
      .map { [weak self] in // [weak self]
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
          // maxCount체크 후, 이상 없으면
          selectedAlbumPhoto.indexArray.append(indexPathItem)
          self?.photoDetailEntity.photoModel.selectedOrder = .selected(selectedAlbumPhoto.count)
          return State.setOrder(selectedAlbumPhoto.count)
        }
      }
      .eraseToAnyPublisher()
  }
}
/*
 orderView tap
 이미 눌려있다면,
 orderCount -= 1 갱신
 order 제거
 (이때 추후에 또 눌린다면, orderCount를 texting)
 
 
 안눌려있다면,
 orderCount += 1 갱신
 order 추가하기(orderCount texting)
 */


/*
 PHAsset, selectedIndexArray, indexPath.item
 
 AlbumPhotoDetail에서 orderView 클릭 시,
 if selectedIndexArray를 순회해서 element에 indexPath.item가 있다면,
 제거한다는 의미이므로, selectedIndexArray에서 해당 element를 제거한다.
 
 if selectedIndexArray를 순회해서 element에 indexPath.item가 없다면,
 추가 한다는 의미이므로, maxCount제한을 체크하고 그에 따라 처리.
  - maxCount 제한에 걸리지 않는다면, selectedIndexArray에 해당 indexPath.item을 append
  - maxCount 제한에 걸린다면, 무효화 처리
 */
