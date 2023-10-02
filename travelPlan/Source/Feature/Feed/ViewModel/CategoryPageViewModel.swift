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
  
  private lazy var postSearchFilterInfoList: [FeedPostSearchFilterInfo] = travelMainCategory.map {
    .init(travelTheme: $0, travelTrend: .newest)
  }
}

// MARK: - Helpers
extension CategoryPageViewModel {
  
  /// Return scrollBar specific position's leading spacing
  /// - Parameter titleWidth: 특정 categoryViewCell의 title 실제 길이
  /// - Returns: cell에서 title을 제외한 영역중 절반 leading spacing
  func scrollBarLeadingSpacing(_ titleWidth: CGFloat) -> CGFloat {
    return (
      TravelMainThemeCategoryAreaView.Constant.size
        .width - titleWidth) / 2.0
  }
}

// MARK: - CategoryPageViewDataSource
extension CategoryPageViewModel: CategoryPageViewDataSource {
  func travelMainCategoryTitle(at index: Int) -> String {
    return travelMainCategoryTitles[index]
  }
  
  func cellItem(at index: Int) -> TravelMainCategoryViewCell.Model {
    return travelCategoryItems[index]
  }
  
  var numberOfItems: Int {
    travelCategoryItems.count
  }
  
  func postSearchFilterItem(at index: Int) -> FeedPostSearchFilterInfo {
    return postSearchFilterInfoList[index]
  }
}
