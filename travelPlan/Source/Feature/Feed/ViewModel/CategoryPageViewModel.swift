//
//  CategoryPageViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/09.
//

import Foundation

final class CategoryPageViewModel {
  // MARK: - Properties
  private let travelThemeList: [String] = TravelMainThemeType.allCases.map { $0.rawValue }
  // TODO: - 상황에 따라 바텀시트에서 특정 trend를 누를 경우 이 프로퍼티도 갱신해야합니다.
  private(set) var travelTrendState: TravelTrend = .newest
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
    travelThemeList.count
  }

  func categoryViewCellItem(at index: Int) -> String {
    return travelThemeList[index]
  }
}
