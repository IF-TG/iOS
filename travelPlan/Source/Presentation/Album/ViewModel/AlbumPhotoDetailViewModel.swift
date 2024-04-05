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
  private var photoModel: PhotoModel
  private var selectedCount: Int
  
  // MARK: - LifeCycle
  init(photoModel: PhotoModel, selectedCount: Int) {
    self.photoModel = photoModel
    self.selectedCount = selectedCount
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
        State.configureUI(self?.photoModel ?? .init(asset: .init(), selectedOrder: .none))
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
        guard let selectedOrder = self?.photoModel.selectedOrder else { return State.none }
        switch selectedOrder {
        case .selected:
          self?.selectedCount -= 1
          self?.photoModel.selectedOrder = .none
          return State.cancelOrder
        case .none:
          self?.selectedCount += 1
          self?.photoModel.selectedOrder = .selected(self?.selectedCount ?? .zero)
          return State.setOrder(self?.selectedCount ?? .zero)
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
