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
    let viewDidLoad: PassthroughSubject<Void, Never>
    
    init(viewDidLoad: PassthroughSubject<Void, Never> = .init()
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
  private let type: SearchSectionType
  
  var festivalCellViewModels: [TravelDestinationCellViewModel]?
  var campingCellViewModels: [TravelDestinationCellViewModel]?
  var topTenCellViewModels: [SearchTopTenCellViewModel]?
  
  // MARK: - LifeCycle
  init(type: SearchSectionType) {
    self.type = type
  }
}

// MARK: - ViewModelCase
extension SearchMoreDetailViewModel: ViewModelCase {
  func transform(_ input: Input) -> Output {
    return input
      .viewDidLoad
      .map { [weak self] _ in
        self?.fetchData()
        return .none
      }
      .setFailureType(to: ErrorType.self)
      .eraseToAnyPublisher()
  }
}

// MARK: - Private Helpers
extension SearchMoreDetailViewModel {
  private func fetchData() {
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
    self.festivalCellViewModels = .init()
    _ = cellViewModels.map { self.festivalCellViewModels?.append($0) }
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
    self.campingCellViewModels = .init()
    _ = cellViewModels.map { self.campingCellViewModels?.append($0) }
  }
  
  private func fetchTopTenModel() {
    let cellViewModels = SearchTopTenModel.mockModels.map { SearchTopTenCellViewModel(model: $0) }
    self.topTenCellViewModels = .init()
    _ = cellViewModels.map { self.topTenCellViewModels?.append($0) }
  }
}
