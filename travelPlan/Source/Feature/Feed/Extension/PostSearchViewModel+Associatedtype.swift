//
//  PostSearchViewModel+Associatedtype.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/25.
//

import UIKit
import Combine

extension PostSearchViewModel: ViewModelAssociatedType {
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
  }
  
  // MARK: - Error
  enum ErrorType: Error {
    case none
    case unexpected
    case invalidDataSource
    case deallocated
  }
}
