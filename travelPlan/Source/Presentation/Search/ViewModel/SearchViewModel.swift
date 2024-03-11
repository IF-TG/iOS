//
//  SearchViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/29.
//

import Foundation
import Combine

final class SearchViewModel {
  enum Constant {
    static let rankingMaxCount = 3
  }
  typealias Output = AnyPublisher<State, ErrorType>
  
  // MARK: - Input
  struct Input {
    let viewDidLoad: PassthroughSubject<Void, Never>
    let didTapView: PassthroughSubject<Void, Never>
    let didTapSearchButton: PassthroughSubject<String, ErrorType>
    let didTapStarButton: PassthroughSubject<Void, ErrorType>
    let didTaplookingMoreButton: PassthroughSubject<Int, ErrorType>
    
    init(
      viewDidLoad: PassthroughSubject<Void, Never> = .init(),
      didTapView: PassthroughSubject<Void, Never> = .init(),
      didTapSearchButton: PassthroughSubject<String, ErrorType> = .init(),
      didTapStarButton: PassthroughSubject<Void, ErrorType> = .init(),
      didTaplookingMoreButton: PassthroughSubject<Int, ErrorType> = .init()
    ) {
      self.viewDidLoad = viewDidLoad
      self.didTapView = didTapView
      self.didTapSearchButton = didTapSearchButton
      self.didTapStarButton = didTapStarButton
      self.didTaplookingMoreButton = didTaplookingMoreButton
    }
  }
  // MARK: - State
  enum State {
    case goDownKeyboard
    case gotoSearch
    case none
    case showSearchMoreDetail(_ sectionType: SearchSectionType)
  }
  // MARK: - Error
  enum ErrorType: Error {
    case none
    case unexpected
  }
  // MARK: - Properties
  private var dataSource = [SearchSectionModel]()
}

// MARK: - ViewModelCase
extension SearchViewModel: ViewModelCase {
  func transform(_ input: Input) -> Output {
    return Publishers.MergeMany([
      viewDidLoadStream(input),
      didTapCollectionViewStream(input),
      didTapSearchButtonStream(input),
      didTaplookingMoreButton(input)
    ]).eraseToAnyPublisher()
  }
  
  private func viewDidLoadStream(_ input: Input) -> Output {
    return input.viewDidLoad
      .map { [weak self] _ in
        self?.fetchData()
        return State.none
      }
      .setFailureType(to: ErrorType.self)
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
  
  private func didTaplookingMoreButton(_ input: Input) -> Output {
    return input.didTaplookingMoreButton
      .tryMap { sectionIndex in
        return State.showSearchMoreDetail(SearchSectionType(rawValue: sectionIndex) ?? .festival)
      }
      .mapError { $0 as? ErrorType ?? .unexpected }
      .eraseToAnyPublisher()
  }
}

// MARK: - Helpers
extension SearchViewModel {
  func getCellViewModels(in section: Int) -> SearchItemType {
    return dataSource[section].itemType
  }
  
  func fetchHeaderTitle(in section: Int) -> String {
    return dataSource[section].headerTitle
  }
  
  func numberOfItemsInSection(in section: Int) -> Int {
    switch dataSource[section].itemType {
    case let .festival(viewModels):
      return viewModels.count
    case let .camping(viewModels):
      return viewModels.count
    case let .topTen(viewModels):
      return viewModels.count
    }
  }
  
  func numberOfSections() -> Int {
    dataSource.count
  }
}

// MARK: - Private Helpers
extension SearchViewModel {
  private func fetchData() {
    // 네트워크 요청을 수행해서 데이터를 가져옵니다.
    let festivalModels = SearchFestivalModel.mockModels
    let festivalCellViewModels = festivalModels.map { SearchFestivalCellViewModel(model: $0) }
    let festivalHeader = "베스트 축제 🎡"
    dataSource.append(SearchSectionModel.init(itemType: .festival(festivalCellViewModels), headerTitle: festivalHeader))
    
    // mapping entity to view's model
    let campingModels = SearchCampingModel.mockModels.map {
      TravelDestinationModel(id: $0.id,
                             imagePath: $0.imagePath,
                             place: $0.place,
                             secondText: $0.category,
                             thirdText: $0.location,
                             isSelectedButton: $0.isSelectedButton)
    }
    
    
    // let campingCellViewModels = campingModels.map { TravelDestinationCellViewModel(model: $0) }
    let campingCellViewModels = stride(from: campingModels.count-1, through: 0, by: -1).map {
      TravelDestinationCellViewModel(model: campingModels[$0])
    }
    
    
    let famousHeader = "야영, 레포츠 어떠세요? 🏕️"
    dataSource.append(SearchSectionModel(itemType: .camping(campingCellViewModels), headerTitle: famousHeader))
    
    let topTenModels = SearchTopTenModel.mockModels
      .filter { $0.ranking <= Constant.rankingMaxCount }
      .sorted { $0.ranking < $1.ranking }
    let topTenCellViewModels = topTenModels.map { SearchTopTenCellViewModel(model: $0) }
    let topTenHeader = "여행지 TOP 10 🌟"
    dataSource.append(SearchSectionModel.init(itemType: .topTen(topTenCellViewModels), headerTitle: topTenHeader))
  }
}
