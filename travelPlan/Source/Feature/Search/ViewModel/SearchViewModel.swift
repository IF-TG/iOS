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

// MARK: - Public Helpers
extension SearchViewModel {
  func getCellViewModels(in section: Int) -> SearchItemType {
    return dataSource[section].itemType
  }
  
  func fetchHeaderTitle(in section: Int) -> String {
    return dataSource[section].headerTitle
  }
  
  func numberOfItemsInSection(in section: Int) -> Int {
    switch dataSource[section].itemType {
    case .festival(let viewModels):
      return viewModels.count
    case .camping(let viewModels):
      return viewModels.count
    }
  }
  
  func numberOfSections() -> Int {
    dataSource.count
  }
}

// MARK: - Helpers
extension SearchViewModel {
  private func fetchData() {
    // 네트워크 요청을 수행해서 데이터를 가져옵니다.
    let festivalModels = SearchFestivalModel.mockModels
    let festivalViewModels = festivalModels.map { SearchFestivalCellViewModel(model: $0) }
    let festivalHeader = "베스트 축제"
    dataSource.append(SearchSectionModel.init(itemType: .festival(festivalViewModels), headerTitle: festivalHeader))
    
    let campingModels = SearchCampingModel.mockModels
    let campingViewModels = campingModels.map { TravelDestinationCellViewModel(model: $0) }
    let famousHeader = "야영 레포츠 어떠세요?"
    dataSource.append(SearchSectionModel(itemType: .camping(campingViewModels), headerTitle: famousHeader))
  }
}
