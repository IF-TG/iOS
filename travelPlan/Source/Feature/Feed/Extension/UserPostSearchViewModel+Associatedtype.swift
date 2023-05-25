//
//  UserPostSearchViewModel+Associatedtype.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/25.
//

import UIKit
import Combine

extension UserPostSearchViewModel: ViewModelAssociatedType {
  struct Input {
    typealias PS = PassthroughSubject
    let didSelectedItem: PassthroughSubject<IndexPath, Never>
    let didTapDeleteButton: PassthroughSubject<(Int, Int), Never>
    let didTapDeleteAllButton: PassthroughSubject<Void, Never>
    let didTapView: PassthroughSubject<Void, Never>
    let didTapSearchTextField: AnyPublisher<String, Never>
    let didTapSearchButton: PassthroughSubject<String, Never>
    let editingTextField: PassthroughSubject<String, Never>
    let didTapEnterAlertAction: PassthroughSubject<Void, Never>
    
    init(
      didSelectedItem: PS<IndexPath, Never> = PS<IndexPath, Never>(),
      didTapDeleteButton: PS<(Int, Int), Never> = PS<(Int, Int), Never>(),
      didTapDeleteAllButton: PS<Void, Never> = PS<Void, Never>(),
      didTapView: PS<Void, Never> = PS<Void, Never>(),
      didTapSearchTextField: AnyPublisher<String, Never>,
      didTapSearchButton: PS<String, Never> = PS<String, Never>(),
      editingTextField: PS<String, Never> = PS<String, Never>(),
      didTapEnterAlertAction: PS<Void, Never> = PS<Void,
      
      Never>()
    ) {
      self.didSelectedItem = didSelectedItem
      self.didTapDeleteButton = didTapDeleteButton
      self.didTapDeleteAllButton = didTapDeleteAllButton
      self.didTapView = didTapView
      self.didTapSearchTextField = didTapSearchTextField
      self.didTapSearchButton = didTapSearchButton
      self.editingTextField = editingTextField
      self.didTapEnterAlertAction = didTapEnterAlertAction
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
  }
  
  enum ErrorType: Error {
    case none
    case unexpected
  }
  
  typealias Output = AnyPublisher<State, ErrorType>
}
