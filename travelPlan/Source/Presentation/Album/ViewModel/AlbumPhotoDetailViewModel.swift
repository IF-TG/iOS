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
  
  // MARK: - LifeCycle
  init(photoModel: PhotoModel) {
    self.photoModel = photoModel
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
      .map {
        if case .selected(let order) = photoModel.selectedOrder {
          
        }
        return State.none
      }
      .eraseToAnyPublisher()
  }
}
