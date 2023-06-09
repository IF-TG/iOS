//
//  SearchViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/29.
//

import Foundation
import Combine

final class SearchViewModel {
  typealias Output = AnyPublisher<State, ErrorType>
  
  // MARK: - Input
  struct Input {
    let didTapView: PassthroughSubject<Void, Never>
    
    init(
      didTapView: PassthroughSubject<Void, Never> = .init()
    ) {
      self.didTapView = didTapView
    }
  }
  // MARK: - State
  enum State {
    case goDownKeyboard
  }
  // MARK: - Error
  enum ErrorType: Error {
    case none
    case unexpected
  }
  
  // MARK: - Properties
  private var models = SearchSectionItemModel.models
}

// MARK: - ViewModelCase
extension SearchViewModel: ViewModelCase {
  func transform(_ input: Input) -> AnyPublisher<State, ErrorType> {
    return didTapCollectionViewStream(input)
  }
  
  private func didTapCollectionViewStream(_ input: Input) -> Output {
    return input.didTapView
      .map { State.goDownKeyboard }
      .setFailureType(to: ErrorType.self)
      .eraseToAnyPublisher()
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
