//
//  UserPostSearchViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/10.
//

import Foundation
import Combine
import UIKit

final class UserPostSearchViewModel {
  
  typealias Input = UserPostSearchEvent
  typealias Output = AnyPublisher<State, Never>
  typealias State = UserPostSearchState
  
  typealias SectionType = SearchSectionItemModel.SectionType
  
  // MARK: - Properties
  private var model: [SearchSectionItemModel] = [
    SearchSectionItemModel(
      type: .recommendation,
      items: ["추천1", "추천22", "추천33333", "추천444"]
    ),
    SearchSectionItemModel(
      type: .recent,
      items: ["최근검색11111111111", "최근검색22222", "최근검색3333", "최근검색4", "최근검색555"]
    )
  ]
}

extension UserPostSearchViewModel {
  // MARK: - Input
  struct UserPostSearchEvent {
    let didSelectedItem: AnyPublisher<IndexPath, Never>
    let didTapDeleteButton: AnyPublisher<(Int, Int), Never>
    let didTapDeleteAllButton: AnyPublisher<Void, Never>
    let didTapView: AnyPublisher<Void, Never>
    let didTapSearchTextField: AnyPublisher<Void, Never>
    let didTapSearchButton: AnyPublisher<String, Never>
    let editingTextField: AnyPublisher<String, Never>
    let didTapEnterAlertAction: AnyPublisher<Void, Never>
  }
  
  // MARK: - State
  enum UserPostSearchState {
    case none
    case gotoBack
    case gotoSearch(searchText: String)
    case deleteCell(section: Int)
    case deleteAllCells(section: Int)
    case presentAlert
    case changeButtonColor(Bool)
  }
}

// MARK: - ViewModelCase
extension UserPostSearchViewModel: ViewModelCase {
  func transform(_ input: Input) -> Output {
    return Publishers.MergeMany([
      editingTextFieldChain(input),
      didTapShearchButtonChain(input),
      didSelectedItemChain(input),
      didTapDeleteAllButtonChain(input),
      didTapDeleteButtonChain(input),
      didTapEnterAlertActionChain(input)
    ]).eraseToAnyPublisher()
  }
  
  private func editingTextFieldChain(_ input: Input) -> Output {
    return input.editingTextField
      .map { State.changeButtonColor(self.isValueChanged(text: $0)) }
      .eraseToAnyPublisher()
  }
  
  private func didTapShearchButtonChain(_ input: Input) -> Output {
    return input.didTapSearchButton
      .map { searchText -> State in
        return .gotoSearch(searchText: searchText)
      }.eraseToAnyPublisher()
  }
  
  private func didSelectedItemChain(_ input: Input) -> Output {
    return input.didSelectedItem
      .map { [weak self] indexPath -> State in
          .gotoSearch(
            searchText: self?.model[indexPath.section].items[indexPath.item] ?? ""
          )
      }.eraseToAnyPublisher()
  }
  
  private func didTapDeleteAllButtonChain(_ input: Input) -> Output {
    return input.didTapDeleteAllButton
      .map { _ -> State in
        return .presentAlert
      }.eraseToAnyPublisher()
  }
  
  private func didTapDeleteButtonChain(_ input: Input) -> Output {
    return input.didTapDeleteButton
      .map { [weak self] item, section -> State in
        self?.removeItemModel(item: item, section: section)
        return .deleteCell(section: section)
      }.eraseToAnyPublisher()
  }
  
  private func didTapEnterAlertActionChain(_ input: Input) -> Output {
    return input.didTapEnterAlertAction
      .map { [weak self] _ -> State in
        self?.model[SectionType.recent.rawValue].items.removeAll()
        return .deleteAllCells(section: SectionType.recent.rawValue)
      }.eraseToAnyPublisher()
  }
}

// MARK: - Helpers
extension UserPostSearchViewModel {
  private func removeItemModel(item: Int, section: Int) {
    self.model[section].items.remove(at: item)
  }
  
  private func isValueChanged(text: String) -> Bool {
    if text.count > 0 {
      return true
    } else { return false }
  }
}

// MARK: - Public Helpers
extension UserPostSearchViewModel {
  func sizeForItem(at indexPath: IndexPath) -> CGSize {
    // label과 cell간의 padding
    let widthPadding: CGFloat = 13
    let heightPadding: CGFloat = 4
    
    let text = self.model[indexPath.section].items[indexPath.item]
    let textSize = (text as NSString)
      .size(withAttributes: [.font: UIFont(pretendard: .medium, size: 14)!])
    
    switch indexPath.section {
    case SectionType.recommendation.rawValue:
      return CGSize(
        width: textSize.width + (widthPadding * 2),
        height: textSize.height + (heightPadding * 2)
      )
    case SectionType.recent.rawValue:
      let buttonWidth: CGFloat = 10
      let componentPadding: CGFloat = 4
      let width = textSize.width + componentPadding + buttonWidth + (widthPadding * 2)
      
      return CGSize(
        width: width,
        height: textSize.height + (heightPadding * 2)
      )
    default: return CGSize()
    }
  }
  
  func numberOfSections() -> Int {
    return SectionType.allCases.count
  }
  
  func cellForItem(
    _ searchTagCell: SearchTagCell,
    at indexPath: IndexPath
  ) -> String {
    // 하나의 Cell class를 재사용해서 변형시키므로, section별로 Cell 구분화
    switch indexPath.section {
    case SearchSection.recommendation.rawValue:
      searchTagCell.initSectionType(with: .recommendation)
    case SearchSection.recent.rawValue:
      searchTagCell.initSectionType(with: .recent)
    default: break
    }
    searchTagCell.deleteButton?.tag = indexPath.item
    
    return self.model[indexPath.section].items[indexPath.item]
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return self.model[section].items.count
  }
  
  func fetchHeaderTitle(
    _ headerView: UserPostSearchHeaderView,
    at section: Int
  ) -> String {
    switch section {
    case SearchSection.recommendation.rawValue:
      headerView.initSectionType(with: .recommendation)
      return SectionType.recommendation.title
    case SearchSection.recent.rawValue:
      headerView.initSectionType(with: .recent)
      return SectionType.recent.title
    default: return ""
    }
  }
  
  func isRecentSection(at section: Int) -> Bool {
    return section == SectionType.recent.rawValue
  }
}
