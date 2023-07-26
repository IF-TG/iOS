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
    case setButtonColor
    case none
  }
  // MARK: - Error
  enum ErrorType: Error {
    case none
    case unexpected
  }
  // MARK: - Properties
  private var sections: [SearchSection] = []
}

// MARK: - ViewModelCase
extension SearchViewModel: ViewModelCase {
  func transform(_ input: Input) -> Output {
    return Publishers.MergeMany([
      viewDidLoadStream(input),
      didTapCollectionViewStream(input),
      didTapSearchButtonStream(input),
      didTapHeartButtonStream(input)
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
  
  private func didTapHeartButtonStream(_ input: Input) -> Output {
    return input.didTapHeartButton
      .tryMap { _ in
        State.setButtonColor
      } // 서버 응답에 따라 Bool값 달라짐
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
  func getCellViewModels(in section: Int) -> SearchSection {
    return sections[section]
  }
  
  func fetchHeaderTitle(in section: Int) -> SearchHeaderModel {
    switch sections[section] {
    case .festival(_, let header):
      return header
    case .famous(_, let header):
      return header
    }
  }
  
  func numberOfItemsInSection(in section: Int) -> Int {
    switch sections[section] {
    case .festival(let viewModels, _):
      return viewModels.count
    case .famous(let viewModels, _):
      return viewModels.count
    }
  }
  
  func numberOfSections() -> Int {
    return sections.count
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
    let festivalModels = SearchFestivalModel.models
    let festivalViewModels = festivalModels.map { SearchBestFestivalCellViewModel(model: $0) }
    let festivalHeader = SearchHeaderModel(title: "베스트 축제")
    sections.append(.festival(festivalViewModels, festivalHeader))
    
    let famousModels = SearchFamousSpotModel.models
    let famousViewModels = famousModels.map { SearchFamousSpotCellViewModel(model: $0) }
    let famousHeader = SearchHeaderModel(title: "야영 레포츠 어떠세요?")
    sections.append(.famous(famousViewModels, famousHeader))
  }
}

/*
 load 메소드 내에서 서버에서 model값 가지고 온 것을 items.send 하기
 
 */
