//
//  CategoryPageViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/09.
//

import Foundation

final class CategoryPageViewModel {
  // MARK: - Properties
  let data = categoryData
  let mockPostData = MockPostModel().initMockData()
}

// MARK: - Public helpers
extension CategoryPageViewModel {
  
  /// Return scrollBar specific position's leading spacing
  /// - Parameter titleWidth: 특정 categoryViewCell의 title 실제 길이
  /// - Returns: cell에서 title을 제외한 영역중 절반 leading spacing
  func scrollBarLeadingSpacing(_ titleWidth: CGFloat) -> CGFloat {
    return (
      CategoryView.Constant.size
        .width - titleWidth) / 2.0
  }
}

// MARK: - CategoryPageViewDataSource
extension CategoryPageViewModel: CategoryPageViewDataSource {
  var numberOfItems: Int {
    data.count
  }
  
  func categoryDetailViewCellItem(at index: Int) -> [PostModel] {
    return mockPostData
  }
  
  func categoryViewCellItem(at index: Int) -> String {
    return data[index]
  }
}
