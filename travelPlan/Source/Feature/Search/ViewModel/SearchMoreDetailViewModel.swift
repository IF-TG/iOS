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
  
  // MARK: - Properties
  /// festival, camping이 해당 프로퍼티를 공통으로 사용합니다.
  var travelDestinationCellViewModels: [TravelDestinationCellViewModel]?
  var topTenCellViewModels: [SearchTopTenCellViewModel]?
  private (set) var headerInfo: SearchDetailHeaderInfo?
}

// MARK: - ViewModelCase
extension SearchMoreDetailViewModel: ViewModelCase {
  func transform(_ input: Input) -> Output {
    return input
      .viewDidLoad
      .map { [weak self] type in
        self?.fetchData(type: type)
        return .none
      }
      .setFailureType(to: ErrorType.self)
      .eraseToAnyPublisher()
  }
}

// MARK: - Private Helpers
extension SearchMoreDetailViewModel {
  private func fetchData(type: SearchSectionType) {
    switch type {
    case .festival:
      fetchFestivalModel()
    case .camping:
      fetchCampingModel()
    case .topTen:
      fetchTopTenModel()
    }
  }
  
  private func fetchFestivalModel() {
    let models = SearchFestivalModel.mockModels.map {
      TravelDestinationModel(id: $0.id,
                             imagePath: $0.imagePath,
                             place: $0.title,
                             secondText: $0.makePeriod(),
                             thirdText: $0.location,
                             isSelectedButton: $0.isSelectedButton)
    }
    let cellViewModels = models.map { TravelDestinationCellViewModel(model: $0) }
    self.travelDestinationCellViewModels = .init()
    _ = cellViewModels.map { self.travelDestinationCellViewModels?.append($0) }
    self.headerInfo = SearchDetailHeaderInfo.festivalMock
  }
  
  private func fetchCampingModel() {
    let models = SearchCampingModel.mockModels.map {
      TravelDestinationModel(id: $0.id,
                             imagePath: $0.imagePath,
                             place: $0.place,
                             secondText: $0.category,
                             thirdText: $0.location,
                             isSelectedButton: $0.isSelectedButton)
    }
    let cellViewModels = models.map { TravelDestinationCellViewModel(model: $0) }
    self.travelDestinationCellViewModels = .init()
    _ = cellViewModels.map { self.travelDestinationCellViewModels?.append($0) }
    self.headerInfo = SearchDetailHeaderInfo.campingMock
  }
  
  private func fetchTopTenModel() {
    let cellViewModels = SearchTopTenModel.mockModels
      .sorted { $0.ranking < $1.ranking }
      .map { SearchTopTenCellViewModel(model: $0) }
    self.topTenCellViewModels = .init()
    _ = cellViewModels.map { self.topTenCellViewModels?.append($0) }
    self.headerInfo = SearchDetailHeaderInfo.topTenMock
  }
}

// MARK: - Helpers
extension SearchMoreDetailViewModel {
  func numberOfItems(type: SearchSectionType) -> Int {
    switch type {
    case .festival, .camping:
      return travelDestinationCellViewModels?.count ?? 0
    case .topTen:
      return topTenCellViewModels?.count ?? 0
    }
  }
}
