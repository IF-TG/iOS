//
//  SearchViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/29.
//

import Foundation
import Combine

final class SearchViewModel {
  let models = SearchSectionItemModel.models
}

// MARK: - ViewModelCase
extension SearchViewModel: ViewModelCase {
  func transform(_ input: Input) -> AnyPublisher<State, ErrorType> {
    return input.viewDidLoad
      .map { State.createCompositionalLayout }
      .setFailureType(to: ErrorType.self)
      .eraseToAnyPublisher()
  }
  
  struct Input {
    let viewDidLoad: PassthroughSubject<Void, Never>
  }
  
  enum State {
    case createCompositionalLayout
  }
  
  enum ErrorType: Error {
    case none
    case unexpected
  }
}
