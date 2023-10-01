//
//  SearchMoreDetailViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/09/16.
//

import Foundation
import Combine

final class SearchMoreDetailViewModel {
  typealias Output = AnyPublisher<State, ErrorType>
  
  struct Input {
    let viewDidLoad: PassthroughSubject<SearchSectionType, Never>
    
    init(viewDidLoad: PassthroughSubject<SearchSectionType, Never> = .init()
    ) {
      self.viewDidLoad = viewDidLoad
    }
  }
  
  enum State {
    case none
    case showDetailVC
  }
  
  enum ErrorType: Error {
    case none
    case unexpected
  }
  
  func transform(input: Input) -> Output {
    return input
      .viewDidLoad
      .map { [weak self] type in
//        self?.fetchData(type: type)
        return .none
      }
      .setFailureType(to: ErrorType.self)
      .eraseToAnyPublisher()
  }
}

// MARK: - Helpers
extension SearchMoreDetailViewModel {
//  private func fetchData(type: SearchSectionType) {
//    switch type {
//    case .festival:
//      let festivalModels = SearchFestivalModel.mockModels
//      let festivalViewModels = festivalModels.map {
//        SearchFestivalCellViewModel(model: $0)
//      }
//
//    case .camping:
//      let campingModels = SearchCampingModel.mockModels
//      let comapingViewModels = campingModels.map {
//        Search
//      }
//    }
//  }
}
