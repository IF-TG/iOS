//
//  SearchHistoryViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/10.
//

import Combine
import Foundation

struct SearchHistoryViewModelActions {
  let showTravelDestinationList: (String) -> Void
  let showPostList: (String) -> Void
  let pop: () -> Void
}

protocol SearchHistoryViewModel: ViewModelable, SearchHistoryCollectionViewDataSource
where Input == SearchHistoryViewModelInput,
      State == SearchHistoryViewModelState {}

struct SearchHistoryViewModelInput {
  let didTapBackButton: PassthroughSubject<Void, Never> = .init()
  let viewDidLoad: PassthroughSubject<Void, Never> = .init()
  let didSelectedItem: PassthroughSubject<IndexPath, Never> = .init()
  let didTapRecentSearchTagDeleteButton: PassthroughSubject<IndexPath, Never> = .init()
  let didTapDeleteAllButton: PassthroughSubject<Void, Never> = .init()
  let didChangeSearchTextField: AnyPublisher<String, Never>
  let didTapSearchButton: PassthroughSubject<String, Never> = .init()
  let didTapDeleteAllAlert: PassthroughSubject<Void, Never> = .init()
  let didTapCollectionView: PassthroughSubject<Void, Never> = .init()
  let didTapAlertCancelButton: PassthroughSubject<Void, Never> = .init()
  
  init(didChangeSearchTextField: AnyPublisher<String, Never>) {
    self.didChangeSearchTextField = didChangeSearchTextField
  }
}

enum SearchHistoryViewModelState {
  case unexpectedError(description: String)
  case none
  case resignFirstResponder
  case presentAlert
  case changeButtonColor(Bool)
  case goDownKeyboard
  case reloadSections(sectionIndex: Int)
  case reloadData
}

final class DefaultSearchHistoryViewModel {
  enum Constants {
    enum CollectionView {
      static let edgeInsetWidth: CGFloat = SearchHistoryViewController.Constants
        .CollectionViewLayout.Inset.left + SearchHistoryViewController.Constants
        .CollectionViewLayout.Inset.right
    }
  }
  
  // TODO: - 최근검색에 대한 list를 fetch해주는 usecase를 적용해야 합니다.
  
  // MARK: - Properties
  private var sectionModels: [SearchHistorySectionModel] = []
  private var recentModels: [String] = []
  private let searchType: SearchType
  private let actions: SearchHistoryViewModelActions
  private let useCase: any SearchHistoryUseCase
  
  // MARK: - LifeCycle
  init(
    searchType: SearchType,
    actions: SearchHistoryViewModelActions,
    useCase: any SearchHistoryUseCase
  ) {
    self.searchType = searchType
    self.actions = actions
    self.useCase = useCase
  }
  
  deinit {
    print("deinit: \(DefaultSearchHistoryViewModel.self)")
  }
}

// MARK: - Helpers
extension DefaultSearchHistoryViewModel: SearchHistoryViewModel {
  func transform(_ input: Input) -> Output {
    return Publishers.MergeMany([
      viewDidLoadStream(input),
      didChangeSearchTextFieldStream(input),
      didTapSearchButtonStream(input),
      didSelectedItemStream(input),
      didTapDeleteAllButtonStream(input),
      didTapRecentSeaerchTagDeleteButtonStream(input),
      didTapDeleteAllAlertStream(input),
      didTapCollectionViewStream(input),
      didTapAlertCancelButtonStream(input),
      didTapBackButtonStream(input)
    ]).eraseToAnyPublisher()
  }
}

// MARK: - Private Helpers
extension DefaultSearchHistoryViewModel {
  private func viewDidLoadStream(_ input: Input) -> Output {
    return input.viewDidLoad
      .flatMap { [weak self] in
        guard let self else { return Just(State.none).eraseToAnyPublisher() }
        
        return self.useCase.fetchHistories(page: nil, perPage: nil)
          .map { searchHistories -> State in
            // recommendation
            self.sectionModels.append(
              SearchHistorySectionModel(
                sectionItem: .recommendation(items: searchHistories.recommendation.map { "#" + $0.keyword }),
                section: .recommendation(title: "추천 검색")
              )
            )
            
            // recent
            let sortedRecentSearchKeyword = searchHistories.recent.sorted { $0 < $1 }.map { $0.keyword }
            
            self.sectionModels.append(
              SearchHistorySectionModel(
                sectionItem: .recent(items: sortedRecentSearchKeyword), section: .recent(title: "최근 검색")
              )
            )
            return State.reloadData
          }
          .catch { Just(State.unexpectedError(description: $0.localizedDescription)).eraseToAnyPublisher() }
          .eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }
  
  private func didTapAlertCancelButtonStream(_ input: Input) -> Output {
    return input.didTapAlertCancelButton
      .map { State.none }
      .eraseToAnyPublisher()
  }
  
  private func didTapCollectionViewStream(_ input: Input) -> Output {
    return input.didTapCollectionView
      .map { State.goDownKeyboard }
      .eraseToAnyPublisher()
  }
  
  private func didChangeSearchTextFieldStream(_ input: Input) -> Output {
    return input.didChangeSearchTextField
      .map { [weak self] in
        State.changeButtonColor(self?.isValueChanged(text: $0) ?? false)
      }
      .eraseToAnyPublisher()
  }
  
  private func didTapSearchButtonStream(_ input: Input) -> Output {
    return input.didTapSearchButton
      .map { [weak self] text in
        guard let self = self else { return State.none }
        switch searchType {
        case .travelDestination:
          actions.showTravelDestinationList(text)
        case .post:
          actions.showPostList(text)
        }
        return State.none
      }
      .eraseToAnyPublisher()
  }
  
  private func didSelectedItemStream(_ input: Input) -> Output {
    return input.didSelectedItem
      .map { [weak self] indexPath in
        var searchText = ""
        
        switch self?.sectionModels[indexPath.section].sectionItem {
        case let .recommendation(items):
          searchText = items[indexPath.item]
        case let .recent(items):
          searchText = items[indexPath.item]
        case .none:
          break
        }
        
        guard let self = self else { return State.none }
        
        switch searchType {
        case .travelDestination:
          actions.showTravelDestinationList(searchText)
        case .post:
          actions.showPostList(searchText)
        }
        return State.resignFirstResponder
      }
      .eraseToAnyPublisher()
  }
  
  private func didTapDeleteAllButtonStream(_ input: Input) -> Output {
    return input.didTapDeleteAllButton
      .map { _ in State.presentAlert }
      .eraseToAnyPublisher()
  }
  
  private func didTapRecentSeaerchTagDeleteButtonStream(_ input: Input) -> Output {
    return input.didTapRecentSearchTagDeleteButton
      .map { [weak self] indexPath in
        self?.removeRecentItem(at: indexPath.item)
        return .reloadSections(sectionIndex: indexPath.section)
      }
      .eraseToAnyPublisher()
  }
  
  private func didTapDeleteAllAlertStream(_ input: Input) -> Output {
    return input.didTapDeleteAllAlert
      .flatMap { [weak self] _ in
        // TODO: - 추후 서버와의 통신을 통해 delete를 수행해야합니다.
        return Future { promise in
          DispatchQueue.global().asyncAfter(deadline: .now()) { [weak self] in
            self?.removeAllRecentItems()
            promise(.success(.reloadSections(sectionIndex: SearchHistorySection.recent.rawValue)))
          }
        }
      }
      .eraseToAnyPublisher()
  }
  
  private func didTapBackButtonStream(_ input: Input) -> Output {
    return input.didTapBackButton
      .map { [weak self] in
        self?.actions.pop()
        return State.none
      }
      .eraseToAnyPublisher()
  }
  
  private func removeAllRecentItems() {
    self.recentModels.removeAll()
    updateRecentItem(with: recentModels)
  }
  
  private func removeRecentItem(at index: Int) {
    self.recentModels.remove(at: index)
    updateRecentItem(with: recentModels)
  }
  
  private func updateRecentItem(with recentItems: [String]) {
    guard let index = self.sectionModels.firstIndex(where: isRecentSection(item:)) else {
      return
    }
    
    sectionModels[index].sectionItem = .recent(items: recentItems)
  }
  
  // recent section이 있는지 확인합니다.
  private func isRecentSection(item: SearchHistorySectionModel) -> Bool {
    if case .recent = item.sectionItem {
      return true
    } else {
      return false
    }
  }
  
  private func isValueChanged(text: String) -> Bool {
    if text.count > 0 {
      return true
    } else { return false }
  }
}

// MARK: - SearchHistoryCollectionViewDataSource
extension DefaultSearchHistoryViewModel {
  func getTextString(at indexPath: IndexPath) -> String {
    switch sectionModels[indexPath.section].sectionItem {
    case let .recent(items): return items[indexPath.item]
    case let .recommendation(items): return items[indexPath.item]
    }
  }
  
  func numberOfSections() -> Int {
    return sectionModels.count
  }
  
  func cellForItems(at section: Int) -> SearchHistorySectionModel.Item {
    return sectionModels[section].sectionItem
  }
  
  func numberOfItems(in section: Int) -> Int {
    switch sectionModels[section].sectionItem {
    case let .recommendation(items):
      return items.count
    case let .recent(items):
      return items.count
    }
  }

  func fetchHeaderTitle(in section: Int) -> SearchHistorySectionModel.Section {
    return sectionModels[section].section
  }
}
