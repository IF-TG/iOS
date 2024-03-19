//
//  AlbumViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 3/19/24.
//

import Foundation
import Combine

protocol AlbumViewModelable: ViewModelable
where AlbumViewModelInput == Input,
      AlbumViewModelState == State,
      AnyPublisher<State, Never> == Output { }

struct AlbumViewModelInput {
  let viewDidLoad: PassthroughSubject<Void, Never> = .init()
  let didSelectedPhoto: PassthroughSubject<Void, Never> = .init()
  let touchBeganCell: PassthroughSubject<Void, Never> = .init()
}

enum AlbumViewModelState {
  case showDetailPhoto
  case setOrder
  
}

final class AlbumViewModel: AlbumViewModelable {
  func transform(_ input: AlbumViewModelInput) -> AnyPublisher<AlbumViewModelState, Never> {
    <#code#>
  }
}
