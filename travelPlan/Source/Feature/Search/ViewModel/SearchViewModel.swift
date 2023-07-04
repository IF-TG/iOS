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
    let didTapSearchButton: PassthroughSubject<String, ErrorType>
    let didTapHeartButton: PassthroughSubject<Void, ErrorType>
    
    init(
      didTapView: PassthroughSubject<Void, Never> = .init(),
      didTapSearchButton: PassthroughSubject<String, ErrorType> = .init(),
      didTapHeartButton: PassthroughSubject<Void, ErrorType> = .init()
    ) {
      self.didTapView = didTapView
      self.didTapSearchButton = didTapSearchButton
      self.didTapHeartButton = didTapHeartButton
    }
  }
  // MARK: - State
  enum State {
    case goDownKeyboard
    case gotoSearch
    case setButtonColor
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
    return Publishers.MergeMany([
      didTapCollectionViewStream(input),
      didTapSearchButtonStream(input),
      didTapHeartButton(input)
    ]).eraseToAnyPublisher()
  }
  
  private func didTapHeartButton(_ input: Input) -> Output {
    return input.didTapHeartButton
    // 서버에 하트 저장
      .tryMap { State.setButtonColor } // 서버 응답에 따라 Bool값 달라짐
      .mapError { $0 as? ErrorType ?? .unexpected }
      .eraseToAnyPublisher()
  }
  
  private func didTapCollectionViewStream(_ input: Input) -> Output {
    return input.didTapView
      .map { State.goDownKeyboard }
      .setFailureType(to: ErrorType.self)
      .eraseToAnyPublisher()
  }
  
  private func didTapSearchButtonStream(_ input: Input) -> Output {
    return input.didTapSearchButton
      .tryMap { text in
        print("DEBUG: '\(text)' search")
        return State.gotoSearch
      }
      .mapError { $0 as? ErrorType ?? .unexpected }
      .eraseToAnyPublisher()
    
  }
}

// MARK: - Public Helpers
extension SearchViewModel {
  func fetchModel(in section: Int) -> SearchSectionItemModel.SearchSection {
    return models[section]
  }
  
  func fetchHeaderTitle(in section: Int) -> String {
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
