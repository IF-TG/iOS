//
//  PostSearchViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/10.
//

import Combine
import Foundation

final class PostSearchViewModel {
  
  // MARK: - Properties
  private var dataSource: [PostSearchSectionModel] = []
  private var recentModels: [String] = []
  
  // MARK: - LifeCycle
  deinit {
    print("deinit: \(Self.self)")
  }
}

// MARK: - ViewModelCase
extension PostSearchViewModel: ViewModelCase {
  typealias Output = AnyPublisher<State, ErrorType>
  
  func transform(_ input: Input) -> Output {
    return Publishers.MergeMany([
      viewDidLoadStream(input),
      didChangeTextFieldStream(input),
      didTapShearchButtonStream(input),
      didSelectedItemStream(input),
      didTapDeleteAllButtonStream(input),
      didTapRecentSeaerchTagDeleteButtonStream(input),
      didTapDeleteAllAlertStream(input),
      didTapBackButtonStream(input),
      didTapCollectionViewStream(input),
      didTapAlertCancelButtonStream(input)
    ]).eraseToAnyPublisher()
  }
  
  private func viewDidLoadStream(_ input: Input) -> Output {
    return input.viewDidLoad
      .map { [weak self] in
        self?.loadData()
        return State.none
      }
      .setFailureType(to: ErrorType.self)
      .eraseToAnyPublisher()
  }
  
  private func didTapAlertCancelButtonStream(_ input: Input) -> Output {
    return input.didTapAlertCancelButton
      .tryMap {
        print("DEBUG: 취소 버튼 클릭됨")
        return State.runtoCancelLogic
      }
      .mapError { _ in ErrorType.unexpected }
      .eraseToAnyPublisher()
  }
  
  private func didTapCollectionViewStream(_ input: Input) -> Output {
    return input.didTapCollectionView
      .tryMap { State.goDownKeyboard }
      .mapError { _ in ErrorType.none }
      .eraseToAnyPublisher()
  }
  
  private func didTapBackButtonStream(_ input: Input) -> Output {
    return input.didTapBackButton
      .tryMap { State.gotoBack }
      .mapError { _ in ErrorType.none }
      .eraseToAnyPublisher()
  }
  
  private func didChangeTextFieldStream(_ input: Input) -> Output {
    let changeButtonColor = input.didChangeSearchTextField
      .map { [weak self] in
        State.changeButtonColor(self?.isValueChanged(text: $0) ?? false)
      }
      .setFailureType(to: ErrorType.self)
      .eraseToAnyPublisher()
    
    let showRecommendationCollection = input.didChangeSearchTextField
      .map { _ in State.showRecommendationCollection }
      .setFailureType(to: ErrorType.self)
      .eraseToAnyPublisher()
    
    return Publishers.Merge(changeButtonColor, showRecommendationCollection)
      .eraseToAnyPublisher()
  }
  
  private func didTapShearchButtonStream(_ input: Input) -> Output {
    return input.didTapSearchButton
      .tryMap { State.gotoSearch(searchText: $0) }
      .mapError { $0 as? ErrorType ?? .unexpected }
      .eraseToAnyPublisher()
  }
  
  private func didSelectedItemStream(_ input: Input) -> Output {
    return input.didSelectedItem
      .tryMap { [weak self] indexPath in
        var searchText = ""
        
        switch self?.dataSource[indexPath.section].sectionItem {
        case let .recommendation(items):
          searchText = items[indexPath.item]
        case let .recent(items):
          searchText = items[indexPath.item]
        case .none:
          throw ErrorType.invalidDataSource
        }
        
        return State.gotoSearch(searchText: searchText)
      }
      .mapError { $0 as? ErrorType ?? .unexpected }
      .eraseToAnyPublisher()
  }
  
  private func didTapDeleteAllButtonStream(_ input: Input) -> Output {
    return input.didTapDeleteAllButton
      .tryMap { State.presentAlert }
      .mapError { $0 as? ErrorType ?? .unexpected }
      .eraseToAnyPublisher()
  }
  
  private func didTapRecentSeaerchTagDeleteButtonStream(_ input: Input) -> Output {
    return input.didTapRecentSearchTagDeleteButton
      .tryMap { [weak self] index in
        self?.removeRecentItem(at: index)
        return .reloadData
      }
      .mapError { $0 as? ErrorType ?? .unexpected }
      .eraseToAnyPublisher()
  }
  
  private func didTapDeleteAllAlertStream(_ input: Input) -> Output {
    return input.didTapDeleteAllAlert
      .flatMap { [weak self] in
        // networkTODO: - 추후 서버와의 통신을 통해 delete를 수행해야합니다.
        // bindingTestTODO: - 바인딩이 잘 되었는지 확인하기
        return Future { promise in
          DispatchQueue.global().asyncAfter(deadline: .now()) { [weak self] in
            self?.removeAllRecentItems()
            promise(.success(.reloadData))
          }
        }
      }
      .mapError { $0 as? ErrorType ?? .unexpected }
      .eraseToAnyPublisher()
  }
}

// MARK: - Helpers
extension PostSearchViewModel {
  private func loadData() {
    // recommendation
    dataSource.append(
      PostSearchSectionModel(
        sectionItem: .recommendation(items: PostSearchSectionModel.createRecommendationMock()),
        section: .recommendation(title: PostSearchSectionModel.createRecommendationHeaderMock())
      )
    )
    
    // recent
    self.recentModels = PostSearchSectionModel.createRecentMock()
    dataSource.append(
      PostSearchSectionModel(
        sectionItem: .recent(items: recentModels),
        section: .recent(title: PostSearchSectionModel.createRecentHeaderMock())
      )
    )
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
    guard let index = self.dataSource.firstIndex(where: isRecentSection(item:)) else {
      return
    }
    
    dataSource[index].sectionItem = .recent(items: recentItems)
  }
  
  // recent section이 있는지 확인합니다.
  private func isRecentSection(item: PostSearchSectionModel) -> Bool {
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

// MARK: - Public Helpers
extension PostSearchViewModel {
  func getTextString(at indexPath: IndexPath) -> String {
    switch dataSource[indexPath.section].sectionItem {
    case let .recent(items): return items[indexPath.item]
    case let .recommendation(items): return items[indexPath.item]
    }
  }
  
  func numberOfSections() -> Int {
    return dataSource.count
  }
  
  func cellForItems(at section: Int) -> PostSearchSectionModel.Item {
    return dataSource[section].sectionItem
  }
  
  func numberOfItems(in section: Int) -> Int {
    switch dataSource[section].sectionItem {
    case let .recommendation(items):
      return items.count
    case let .recent(items):
      return items.count
    }
  }

  func fetchHeaderTitle(in section: Int) -> PostSearchSectionModel.Section {
    return dataSource[section].section
  }
}
