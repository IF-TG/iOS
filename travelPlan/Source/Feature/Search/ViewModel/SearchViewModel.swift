//
//  SearchViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/29.
//

import Foundation
import Combine

final class SearchViewModel {
  // MARK: - Properties
  private var models = SearchSectionItemModel.models
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

// MARK: - Public Helpers
extension SearchViewModel {
  func getModel(in section: Int) -> SearchSectionItemModel.SearchSection {
    return models[section]
  }
  
  func getHeaderTitle(in section: Int) -> String {
    return models[section].headerTitle
  }
  
  func numberOfItemsInSection(in section: Int) -> Int {
    switch models[section] {
    case let .bestFestival(festivalItems):
      return festivalItems.count
    case let .famousSpot(spotItems):
      return spotItems.count
    }
  }
  
  func numberOfSections() -> Int {
    return models.count
  }
}
