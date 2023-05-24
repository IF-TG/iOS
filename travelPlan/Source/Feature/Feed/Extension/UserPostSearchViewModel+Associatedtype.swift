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
    let didSelectedItem: AnyPublisher<IndexPath, Never>
    let didTapDeleteButton: AnyPublisher<(Int, Int), Never>
    let didTapDeleteAllButton: AnyPublisher<Void, Never>
    let didTapView: AnyPublisher<Void, Never>
    let didTapSearchTextField: AnyPublisher<Void, Never>
    let didTapSearchButton: AnyPublisher<String, Never>
    let editingTextField: AnyPublisher<String, Never>
    let didTapEnterAlertAction: AnyPublisher<Void, Never>
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
