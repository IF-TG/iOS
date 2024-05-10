//
//  SearchDestinationViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 4/28/24.
//

import Foundation
import Combine

protocol SearchDestinationViewModel: ViewModelable
where Input == SearchDestinationViewModelInput,
      State == SearchDestinationViewModelState,
      Output == AnyPublisher<State, Never> { }

struct SearchDestinationViewModelInput {
  let viewDidLoad: PassthroughSubject<DestinationType, Never> = .init()
}

enum SearchDestinationViewModelState {
  case none
  case setupContent(type: DestinationType)
}

// MARK: - SearchDestinationViewModel
final class DefaultSearchDestinationViewModel: SearchDestinationViewModel {
  func transform(_ input: Input) -> Output {
//    return Publishers.MergeMany(viewDidLoadStream)
//      .eraseToAnyPublisher()
    return viewDidLoadStream(input)
  }
}

// MARK: - Private Helpers
extension DefaultSearchDestinationViewModel {
  private func viewDidLoadStream(_ input: Input) -> Output {
    // TODO: - type에 따라서 type에 맞게 data fetch 후, vc의 type에 맞게 content view구조를 보여주어야합니다.
    return input.viewDidLoad
//      .map { return State.setupContent(type: <#T##DestinationType#>) }
      .map { _ in return State.none }
      .eraseToAnyPublisher()
  }
}
