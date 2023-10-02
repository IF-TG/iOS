//
//  CategoryPageViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/09.
//

import Foundation

final class CategoryPageViewModel {
  // MARK: - Properties
  private var travelMainCategory: [TravelMainThemeType] {
    TravelMainThemeType.allCases
  }
  
  private lazy var travelMainCategoryTitles: [String] = {
    travelMainCategory.map { $0.rawValue }
  }()
  
  private lazy var travelCategoryItems: [TravelMainCategoryViewCell.Model] = travelMainCategory.map {
    .init(cagtegoryTitle: $0.rawValue, imagePath: $0.imagePath)
  }
  
  // TODO: - 상황에 따라 바텀시트에서 특정 trend를 누를 경우 이 프로퍼티도 갱신해야합니다.
  private(set) var travelTrendState: TravelOrderType = .newest
}

// MARK: - Public helpers
extension CategoryPageViewModel {
  
  /// Return scrollBar specific position's leading spacing
  /// - Parameter titleWidth: 특정 categoryViewCell의 title 실제 길이
  /// - Returns: cell에서 title을 제외한 영역중 절반 leading spacing
  func scrollBarLeadingSpacing(_ titleWidth: CGFloat) -> CGFloat {
    return (
      TravelMainCategoryView.Constant.size
        .width - titleWidth) / 2.0
  }
}

// MARK: - CategoryPageViewDataSource
extension CategoryPageViewModel: CategoryPageViewDataSource {
  func travelMainCategoryTitle(at index: Int) -> String {
    return travelMainCategoryTitles[index]
  }
  
  func categoryViewCellItem(at index: Int) -> TravelMainCategoryViewCell.Model {
    return travelCategoryItems[index]
  }
  
  var numberOfItems: Int {
    travelCategoryItems.count
  }
}
