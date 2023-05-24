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
  typealias SectionType = SearchSectionItemModel.SectionType
  
  // MARK: - Properties
  private var model: [SearchSectionItemModel] = [
    SearchSectionItemModel(
      type: .recommendation,
      items: ["추천1", "추천22", "추천33333", "추천444"]
    ),
    SearchSectionItemModel(
      type: .recent,
      items: ["최근검색11", "최근검색22222", "최근검색3333", "최근검색4", "최근검색555"]
    )
  ]
}

extension UserPostSearchViewModel {
  // MARK: - Input
  struct Input {
    let didSelectedItem: AnyPublisher<IndexPath, Never>
    let didTapDeleteButton: AnyPublisher<(Int, Int), Never>
    let didTapDeleteAllButton: AnyPublisher<Void, Never>
    let didTapCollectionView: AnyPublisher<Void, Never>
    let didTapSearchButton: AnyPublisher<String, Never>
    let editingTextField: AnyPublisher<String, Never>
    let didTapEnterAlertAction: AnyPublisher<Void, Never>
    let didTapBackButton: AnyPublisher<Void, Never>
  }

  // MARK: - State
  enum State {
    case none
    case gotoBack
    case gotoSearch(searchText: String)
    case deleteCell(section: Int)
    case deleteAllCells(section: Int)
    case presentAlert
    case changeButtonColor(Bool)
    case goDownKeyboard
  }
  
  // MARK: - ViewModelError
  enum Error { }
}

// MARK: - ViewModelCase
extension UserPostSearchViewModel: ViewModelCase {
  typealias Output = AnyPublisher<State, Never>
  
  func transform(_ input: Input) -> Output {
    return Publishers.MergeMany([
      editingTextFieldChain(input),
      didTapShearchButtonChain(input),
      didSelectedItemChain(input),
      didTapDeleteAllButtonChain(input),
      didTapDeleteButtonChain(input),
      didTapEnterAlertActionChain(input),
      didTapBackButtonChain(input),
      didTapCollectionViewChain(input)
    ]).eraseToAnyPublisher()
  }
  
  private func didTapCollectionViewChain(_ input: Input) -> Output {
    return input.didTapCollectionView
      .map { .goDownKeyboard }
      .eraseToAnyPublisher()
  }
  
  private func didTapBackButtonChain(_ input: Input) -> Output {
    return input.didTapBackButton
      .map { .gotoBack }
      .eraseToAnyPublisher()
  }
  
  private func editingTextFieldChain(_ input: Input) -> Output {
    return input.editingTextField
      .map { [weak self] in
        .changeButtonColor(self?.isValueChanged(text: $0) ?? false)
      }.eraseToAnyPublisher()
  }
  
  private func didTapShearchButtonChain(_ input: Input) -> Output {
    return input.didTapSearchButton
      .map { .gotoSearch(searchText: $0) }
      .eraseToAnyPublisher()
  }
  
  private func didSelectedItemChain(_ input: Input) -> Output {
    return input.didSelectedItem
      .map { [weak self] in
        .gotoSearch(searchText: self?.model[$0.section].items[$0.item] ?? "") }
      .eraseToAnyPublisher()
  }
  
  private func didTapDeleteAllButtonChain(_ input: Input) -> Output {
    return input.didTapDeleteAllButton
      .map { .presentAlert }
      .eraseToAnyPublisher()
  }
  
  private func didTapDeleteButtonChain(_ input: Input) -> Output {
    return input.didTapDeleteButton
      .map { [weak self] in
        self?.removeItemModel(item: $0, section: $1)
        return .deleteCell(section: $1)
      }.eraseToAnyPublisher()
  }
  
  private func didTapEnterAlertActionChain(_ input: Input) -> Output {
    return input.didTapEnterAlertAction
      .map { [weak self] in
        self?.model[SectionType.recent.rawValue].items.removeAll()
        return .deleteAllCells(section: SectionType.recent.rawValue)
      }.eraseToAnyPublisher()
  }
}

// MARK: - Helpers
extension UserPostSearchViewModel {
  private func removeItemModel(item: Int, section: Int) {
    model[section].items.remove(at: item)
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
    
    let text = model[indexPath.section].items[indexPath.item]
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
    
    return model[indexPath.section].items[indexPath.item]
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return model[section].items.count
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
