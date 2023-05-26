//
//  UserPostSearchViewModel+Associatedtype.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/25.
//

import UIKit
import Combine

extension UserPostSearchViewModel: ViewModelAssociatedType {
  typealias Output = AnyPublisher<State, ErrorType>
  
  struct Input {
    let didSelectedItem: PassthroughSubject<IndexPath, Never>
    let didTapDeleteButton: PassthroughSubject<(Int, Int), Never>
    let didTapDeleteAllButton: PassthroughSubject<Void, Never>
    let didTapView: PassthroughSubject<Void, Never>
    let didChangeSearchTextField: AnyPublisher<String, Never>
    let didTapSearchButton: PassthroughSubject<String, Never>
    let didTapAlertConfirmButton: PassthroughSubject<Void, Never>
    let didTapCollectionView: PassthroughSubject<Void, Never>
    let didTapBackButton: PassthroughSubject<Void, Never>
    
    init(
      didSelectedItem: PassthroughSubject<IndexPath, Never> = .init(),
      didTapDeleteButton: PassthroughSubject<(Int, Int), Never> = .init(),
      didTapDeleteAllButton: PassthroughSubject<Void, Never> = .init(),
      didTapView: PassthroughSubject<Void, Never> = .init(),
      didChangeSearchTextField: AnyPublisher<String, Never>,
      didTapSearchButton: PassthroughSubject<String, Never> = .init(),
      didTapEnterAlertAction: PassthroughSubject<Void, Never> = .init(),
      didTapCollectionView: PassthroughSubject<Void, Never> = .init(),
      didTapBackButton: PassthroughSubject<Void, Never> = .init()
    ) {
      self.didSelectedItem = didSelectedItem
      self.didTapDeleteButton = didTapDeleteButton
      self.didTapDeleteAllButton = didTapDeleteAllButton
      self.didTapView = didTapView
      self.didChangeSearchTextField = didChangeSearchTextField
      self.didTapSearchButton = didTapSearchButton
      self.didTapAlertConfirmButton = didTapEnterAlertAction
      self.didTapCollectionView = didTapCollectionView
      self.didTapBackButton = didTapBackButton
    }
  }
  
  enum State {
    case none
    case gotoBack
    case gotoSearch(searchText: String)
    case deleteCell(section: Int)
    case deleteAllCells(section: Int)
    case presentAlert
    case changeButtonColor(Bool)
    case goDownKeyboard
    case showRecommendationCollection
  }
  
  enum ErrorType: Error {
    case none
    case unexpected
  }
}
