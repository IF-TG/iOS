//
//  SearchViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/29.
//

import Foundation
import Combine

protocol SearchViewModelInput {
  associatedtype ErrorType: Error
  
  var viewDidLoad: PassthroughSubject<Void, Never> { get }
  var didTapView: PassthroughSubject<Void, Never> { get }
  var didTapSearchButton: PassthroughSubject<String, ErrorType> { get }
  var didTapHeartButton: PassthroughSubject<Void, ErrorType> { get }
}

final class SearchViewModel {
  typealias Output = AnyPublisher<State, ErrorType>
  
  // MARK: - Input
  struct Input: SearchViewModelInput {
    let viewDidLoad: PassthroughSubject<Void, Never>
    let didTapView: PassthroughSubject<Void, Never>
    let didTapSearchButton: PassthroughSubject<String, ErrorType>
    let didTapHeartButton: PassthroughSubject<Void, ErrorType>
    
    init(
      viewDidLoad: PassthroughSubject<Void, Never> = .init(),
      didTapView: PassthroughSubject<Void, Never> = .init(),
      didTapSearchButton: PassthroughSubject<String, ErrorType> = .init(),
      didTapHeartButton: PassthroughSubject<Void, ErrorType> = .init()
    ) {
      self.viewDidLoad = viewDidLoad
      self.didTapView = didTapView
      self.didTapSearchButton = didTapSearchButton
      self.didTapHeartButton = didTapHeartButton
    }
  }
  // MARK: - State
  enum State {
    case goDownKeyboard
    case gotoSearch
    case none
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
      didTapSearchButtonStream(input)
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
    case .famous(let viewModels):
      return viewModels.count
    }
  }
  
  func numberOfSections() -> Int {
    dataSource.count
  }
}

// MARK: - Helpers
extension SearchViewModel {
  // networkTODO: - Server Communication
  // 이 곳에서 useCase.execute메소드를 호출하고 completionHandler에서 result 처리 해야합니다.
//  private func load() {
//  }
  
  private func fetchData() {
    // 네트워크 요청을 수행해서 데이터를 가져옵니다.
    let festivalModels = SearchFestivalModel.mockModels
    let festivalViewModels = festivalModels.map { SearchBestFestivalCellViewModel(model: $0) }
    let festivalHeader = "베스트 축제"
    dataSource.append(SearchSectionModel.init(itemType: .festival(festivalViewModels), headerTitle: festivalHeader))
    
    let famousModels = SearchFamousSpotModel.mockModels
    let famousViewModels = famousModels.map { TravelDestinationCellViewModel(model: $0) }
    let famousHeader = "야영 레포츠 어떠세요?"
    dataSource.append(SearchSectionModel(itemType: .famous(famousViewModels), headerTitle: famousHeader))
  }
}
