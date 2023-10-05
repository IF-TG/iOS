//
//  PostSearchViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/10.
//

import Combine
import Foundation

final class PostSearchViewModel {
  enum Constants {
    enum CollectionView {
      static let edgeInsetWidth: CGFloat = PostSearchViewController.Constants
        .CollectionViewLayout.Inset.left + PostSearchViewController.Constants
        .CollectionViewLayout.Inset.right
    }
  }
  
  // MARK: - Input
  struct Input {
    let viewDidLoad: PassthroughSubject<Void, Never>
    let didSelectedItem: PassthroughSubject<IndexPath, ErrorType>
    let didTapRecentSearchTagDeleteButton: PassthroughSubject<Int, Never>
    let didTapDeleteAllButton: PassthroughSubject<Void, Never>
    let didChangeSearchTextField: AnyPublisher<String, Never>
    let didTapSearchButton: PassthroughSubject<String, Never>
    let didTapDeleteAllAlert: PassthroughSubject<Void, ErrorType>
    let didTapCollectionView: PassthroughSubject<Void, Never>
    let didTapBackButton: PassthroughSubject<Void, Never>
    let didTapAlertCancelButton: PassthroughSubject<Void, Never>
    
    init(
      viewDidLoad: PassthroughSubject<Void, Never> = .init(),
      didSelectedItem: PassthroughSubject<IndexPath, ErrorType> = .init(),
      didTapRecentSearchTagDeleteButton: PassthroughSubject<Int, Never> = .init(),
      didTapDeleteAllButton: PassthroughSubject<Void, Never> = .init(),
      didChangeSearchTextField: AnyPublisher<String, Never>,
      didTapSearchButton: PassthroughSubject<String, Never> = .init(),
      didTapDeleteAllAlert: PassthroughSubject<Void, ErrorType> = .init(),
      didTapCollectionView: PassthroughSubject<Void, Never> = .init(),
      didTapBackButton: PassthroughSubject<Void, Never> = .init(),
      didTapAlertCancelButton: PassthroughSubject<Void, Never> = .init()
    ) {
      self.viewDidLoad = viewDidLoad
      self.didSelectedItem = didSelectedItem
      self.didTapRecentSearchTagDeleteButton = didTapRecentSearchTagDeleteButton
      self.didTapDeleteAllButton = didTapDeleteAllButton
      self.didChangeSearchTextField = didChangeSearchTextField
      self.didTapSearchButton = didTapSearchButton
      self.didTapDeleteAllAlert = didTapDeleteAllAlert
      self.didTapCollectionView = didTapCollectionView
      self.didTapBackButton = didTapBackButton
      self.didTapAlertCancelButton = didTapAlertCancelButton
    }
  }
  
  // MARK: - State
  enum State {
    case none
    case gotoBack
    case gotoSearch(searchText: String)
    case presentAlert
    case changeButtonColor(Bool)
    case goDownKeyboard
    case showRecommendationCollection
    case runtoCancelLogic
    case reloadData
    case reloadSections(sectionIndex: Int)
  }
  
  // MARK: - Error
  enum ErrorType: Error {
    case none
    case unexpected
    case invalidDataSource
    case deallocated
  }
  
  // MARK: - Properties
  private var sectionModels: [PostSearchSectionModel] = []
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
        
        switch self?.sectionModels[indexPath.section].sectionItem {
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
    let recommendatoinModels = PostSearchSectionModel.createRecommendationMock()
    let transformedModels = recommendatoinModels.map { "#"+$0 }
    
    sectionModels.append(
      PostSearchSectionModel(
        sectionItem: .recommendation(items: transformedModels),
        section: .recommendation(title: PostSearchSectionModel.createRecommendationHeaderMock())
      )
    )
    
    // recent
    self.recentModels = PostSearchSectionModel.createRecentMock()
    sectionModels.append(
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
    guard let index = self.sectionModels.firstIndex(where: isRecentSection(item:)) else {
      return
    }
    
    sectionModels[index].sectionItem = .recent(items: recentItems)
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

// MARK: - PostSearchCollectionViewDataSource
extension PostSearchViewModel: PostSearchCollectionViewDataSource {
  func getTextString(at indexPath: IndexPath) -> String {
    switch sectionModels[indexPath.section].sectionItem {
    case let .recent(items): return items[indexPath.item]
    case let .recommendation(items): return items[indexPath.item]
    }
  }
  
  func numberOfSections() -> Int {
    return sectionModels.count
  }
  
  func cellForItems(at section: Int) -> PostSearchSectionModel.Item {
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

  func fetchHeaderTitle(in section: Int) -> PostSearchSectionModel.Section {
    return sectionModels[section].section
  }
}
