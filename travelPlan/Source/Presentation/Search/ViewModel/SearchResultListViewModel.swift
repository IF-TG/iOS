//
//  SearchResultListViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 5/23/24.
//

import Foundation
import Combine

protocol SearchResultListViewModel: ViewModelable
where Input == SearchResultListViewModelInput,
      State == SearchResultListViewModelState { }

struct SearchResultListViewModelInput {
  let viewDidLoad: PassthroughSubject<Void, Never> = .init()
  let didTapStarButton: PassthroughSubject<IndexPath, Never> = .init()
}

enum SearchResultListViewModelState {
  case none
}

final class DefaultSearchResultListViewModel {
  // MARK: - Properties
  
  // MARK: - LifeCycle
}

// MARK: - SearchResultListViewModel
extension DefaultSearchResultListViewModel: SearchResultListViewModel {
  func transform(_ input: Input) -> AnyPublisher<State, Never> {
    Publishers.MergeMany(
      viewDidLoadStream(input),
      didTapStarButtonStream(input)
    )
    .eraseToAnyPublisher()
  }
}

// MARK: - Private Helpers
extension DefaultSearchResultListViewModel {
  private func viewDidLoadStream(_ input: Input) -> Output {
    return input.viewDidLoad
      .map { _ in State.none }
      .eraseToAnyPublisher()
  }
  
  private func didTapStarButtonStream(_ input: Input) -> Output {
    return input.didTapStarButton
      .map { _ in State.none }
      .eraseToAnyPublisher()
  }
}
