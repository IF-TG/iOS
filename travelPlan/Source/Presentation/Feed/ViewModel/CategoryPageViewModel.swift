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
  
  private lazy var travelCategoryItems: [TravelMainCategoryViewCellInfo] = travelMainCategory
    .map {
      .init(cagtegoryTitle: $0.rawValue, imagePath: $0.imagePath)
    }
  
  private lazy var postCateogryList: [PostCategory] = travelMainCategory.map {
    .init(mainTheme: $0, orderBy: .newest)
  }
}

// MARK: - CategoryPageViewDataSource
extension CategoryPageViewModel: CategoryPageViewDataSource {
  func travelMainCategoryTitle(at index: Int) -> String {
    return travelMainCategoryTitles[index]
  }
  
  func cellItem(at index: Int) -> TravelMainCategoryViewCellInfo {
    return travelCategoryItems[index]
  }
  
  var numberOfItems: Int {
    travelCategoryItems.count
  }
  
  func postSearchFilterItem(at index: Int) -> PostCategory {
    return postCateogryList[index]
  }
}
