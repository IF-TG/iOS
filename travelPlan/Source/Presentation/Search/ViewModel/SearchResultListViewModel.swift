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
      State == SearchResultListViewModelState,
      Output == AnyPublisher<State, Never> { }

struct SearchResultListViewModelInput {
  let viewDidLoad: PassthroughSubject<Void, Never> = .init()
  let didTapStarButton: PassthroughSubject<IndexPath, Never> = .init()
}

enum SearchResultListViewModelState {
  
}

final class DefaultSearchResultListViewModel {
  // MARK: - Properties
  
  // MARK: - LifeCycle
}

// MARK: - SearchResultListViewModel
extension DefaultSearchResultListViewModel: SearchResultListViewModel {
  func transform(_ input: Input) -> AnyPublisher<State, Never> {
    <#code#>
  }
}
