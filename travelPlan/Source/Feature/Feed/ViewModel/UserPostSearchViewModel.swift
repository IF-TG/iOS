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
  
  // MARK: - Properties
  var recommendationModel = RecommendationSearch()
  var recentModel = RecentSearch()
}

// MARK: - ViewModelCase
extension UserPostSearchViewModel: ViewModelCase {
  func transform(_ input: Input) -> Output {
    let _viewDidLoad = input.viewDidLoad
      .receive(on: RunLoop.main)
      .map { _ -> State in return .none }
      .eraseToAnyPublisher()
    
    return Publishers.MergeMany([
      _viewDidLoad
    ])
    .eraseToAnyPublisher()
  }
}

// MARK: - Input
struct UserPostSearchEvent {
  let viewDidLoad: AnyPublisher<Void, Never>
  let didTapTagCell: AnyPublisher<Void, Never>
  let didTapDeleteButton: AnyPublisher<Void, Never>
  let didTapDeleteAllButton: AnyPublisher<Void, Never>
  let didTapView: AnyPublisher<Void, Never>
  let didTapSearchTextField: AnyPublisher<Void, Never>
  let didTapCancelButton: AnyPublisher<Void, Never>
  let didTapSearchButton: AnyPublisher<Void, Never>
  let editingTextField: AnyPublisher<Void, Never>
}

// MARK: - State
enum UserPostSearchState {
  case none
  case gotoBack
  case gotoSearch
  case deleteCell
  case deleteAllCells
}

// MARK: - Public Helpers
extension UserPostSearchViewModel {
  func sizeForItem(at indexPath: IndexPath) -> CGSize {
    let widthPadding: CGFloat = 13
    let heightPadding: CGFloat = 4
    
    var text = ""
    
    switch indexPath.section {
    case SearchSection.recommendation.rawValue:
      text = recommendationModel.keywords[indexPath.item]
      let textSize = (text as NSString)
        .size(withAttributes: [.font: UIFont(pretendard: .medium, size: 14)!])
      return CGSize(
        width: textSize.width + (widthPadding * 2),
        height: textSize.height + (heightPadding * 2)
        )
    case SearchSection.recent.rawValue:
      text = recentModel.keywords[indexPath.item]
      let textSize = (text as NSString)
        .size(withAttributes: [.font: UIFont.systemFont(ofSize: 14)])
      
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
  
  func didSelectItem(at indexPath: IndexPath) -> String {
    switch indexPath.section {
    case SearchSection.recommendation.rawValue:
      return recommendationModel.keywords[indexPath.item]
    case SearchSection.recent.rawValue:
      return recentModel.keywords[indexPath.item]
    default: return ""
    }
  }
  
  func numberOfSections() -> Int {
    return SearchSection.allCases.count
  }
  
  func cellForItem(_ searchTagCell: SearchTagCell, at indexPath: IndexPath) -> String {
    // 하나의 Cell class를 재사용해서 변형시키므로, section별로 Cell 구분화
    switch indexPath.section {
    case SearchSection.recommendation.rawValue:
      searchTagCell.initSectionType(with: .recommendation)
      return recommendationModel.keywords[indexPath.item]
    case SearchSection.recent.rawValue:
      searchTagCell.initSectionType(with: .recent)
      return recentModel.keywords[indexPath.item]
    default: break
    }
    return ""
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    switch section {
    case SearchSection.recommendation.rawValue:
      return recommendationModel.keywords.count
    case SearchSection.recent.rawValue:
      return recentModel.keywords.count
    default: return 0
    }
  }
}
