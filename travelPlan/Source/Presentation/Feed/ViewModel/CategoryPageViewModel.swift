//
//  CategoryPageViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/09.
//

import Foundation

final class CategoryPageViewModel {
  // MARK: - Properties
  private let travelMainCategoryTitles: [String]
  
  private let travelCategoryItems: [TravelMainCategoryViewCellInfo]
  
  private let postCategoryList: [PostCategory]
  
  init() {
    let mainThemes = TravelMainThemeType.allCases
    
    travelMainCategoryTitles = mainThemes.map { $0.rawValue }
    travelCategoryItems = mainThemes.map {
      .init(cagtegoryTitle: $0.rawValue, imagePath: $0.imagePath)
    }
    postCategoryList = mainThemes.map {
      let postCategory = PostCategory(mainTheme: $0, orderBy: .newest)
      return postCategory
    }
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
    return postCategoryList[index]
  }
}
