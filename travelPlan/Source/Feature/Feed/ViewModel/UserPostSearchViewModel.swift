//
//  UserPostSearchViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/10.
//

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

// MARK: - ViewModelCase
extension UserPostSearchViewModel: ViewModelCase {
  
  func transform(_ input: Input) -> Output {
    return Publishers.MergeMany([
      didChangeTextFieldStream(input),
      didTapShearchButtonStream(input),
      didSelectedItemStream(input),
      didTapDeleteAllButtonStream(input),
      didTapDeleteButtonStream(input),
      didTapAlertConfirmButtonStream(input),
      didTapBackButtonStream(input),
      didTapCollectionViewStream(input),
      didTapAlertCancelButtonStream(input)
    ]).eraseToAnyPublisher()
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
        State.gotoSearch(
          searchText: self?.model[indexPath.section].items[indexPath.item] ?? ""
        )
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
  
  private func didTapDeleteButtonStream(_ input: Input) -> Output {
    return input.didTapDeleteButton
      .tryMap { [weak self] item, section in
        self?.removeItemModel(item: item, section: section)
        return State.deleteCell(section: section)
      }
      .mapError { $0 as? ErrorType ?? .unexpected }
      .eraseToAnyPublisher()
  }
  
  private func didTapAlertConfirmButtonStream(_ input: Input) -> Output {
    return input.didTapAlertConfirmButton
      .tryMap { [weak self] in
        print("DEBUG: 확인 버튼 클릭됨")
        self?.model[SectionType.recent.index].items.removeAll()
        return State.deleteAllCells(section: SectionType.recent.index)
      }
      .mapError { $0 as? ErrorType ?? .unexpected }
      .eraseToAnyPublisher()
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
    case SectionType.recommendation.index:
      return CGSize(
        width: textSize.width + (widthPadding * 2),
        height: textSize.height + (heightPadding * 2)
      )
    case SectionType.recent.index:
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
  
  func getTagString(
    _ searchTagCell: SearchTagCell,
    at indexPath: IndexPath
  ) -> String {
    // 하나의 Cell class를 재사용해서 변형시키므로, section별로 Cell 구분화
    switch indexPath.section {
    case SectionType.recommendation.index:
      searchTagCell.initSectionType(with: .recommendation)
    case SectionType.recent.index:
      searchTagCell.initSectionType(with: .recent)
    default: break
    }
    searchTagCell.deleteButton?.tag = indexPath.item
    
    return model[indexPath.section].items[indexPath.item]
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return model[section].items.count
  }
  
  func getHeaderTitle(
    _ headerView: UserPostSearchHeaderView,
    at section: Int
  ) -> String {
    switch section {
    case SectionType.recommendation.index:
      headerView.initSectionType(with: .recommendation)
      return SectionType.recommendation.title
    case SectionType.recent.index:
      headerView.initSectionType(with: .recent)
      return SectionType.recent.title
    default: return ""
    }
  }
  
  func isRecentSection(at section: Int) -> Bool {
    return section == SectionType.recent.index
  }
}
