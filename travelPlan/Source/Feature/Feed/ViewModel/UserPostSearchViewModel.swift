//
//  UserPostSearchViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/10.
//

import Foundation
import Combine

final class UserPostSearchViewModel {
  typealias Input = UserPostSearchEvent
  typealias Output = AnyPublisher<State, Never>
  typealias State = UserPostSearchState
  
  // MARK: - Properties
  var recommendationModel = RecommendationSearch()
  var recentModel = RecentSearch()
}

// MARK: - ViewModelCase
extension UserPostSearchViewModel: ViewModelCase {
  func transform(_ input: Input) -> Output {
    let _viewDidLoad = input.viewDidLoad
      .receive(on: RunLoop.main)
      .map { _ -> State in return .none }
      .eraseToAnyPublisher()
    
    return Publishers.MergeMany([
      _viewDidLoad
    ])
    .eraseToAnyPublisher()
  }
}

// MARK: - Input
struct UserPostSearchEvent {
  let viewDidLoad: AnyPublisher<Void, Never>
  let didTapTagCell: AnyPublisher<Void, Never>
  let didTapDeleteButton: AnyPublisher<Void, Never>
  let didTapDeleteAllButton: AnyPublisher<Void, Never>
  let didTapView: AnyPublisher<Void, Never>
  let didTapSearchTextField: AnyPublisher<Void, Never>
  let didTapCancelButton: AnyPublisher<Void, Never>
  let didTapSearchButton: AnyPublisher<Void, Never>
  let editingTextField: AnyPublisher<Void, Never>
}

// MARK: - State
enum UserPostSearchState {
  case none
  case gotoBack
  case gotoSearch
  case deleteCell
  case deleteAllCells
}
