//
//  PostViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/14.
//

import Foundation

final class PostViewModel {
  // MARK: - Properties
  private let data: [PostInfo] = MockPostModel().initMockData()
  
  private(set) var travelTheme: TravelMainThemeType = .all
  
  private(set) var travelTrend: TravelOrderType = .newest
  
    var count: Int {
      data.count
    }
  
  // MARK: - Properteis
  init(filterInfo: FeedPostSearchFilterInfo) {
    self.travelTheme = filterInfo.travelTheme
    self.travelTrend = filterInfo.travelTrend
  }
}

// MARK: - Public helpers
extension PostViewModel {
  func cellItem(_ indexPath: IndexPath) -> PostInfo {
    return data[indexPath.row]
  }
  
  func contentText(_ indexPath: IndexPath) -> String {
    return data[indexPath.row].content.text
  }
}

// MARK: - PostViewAdapterDataSource
extension PostViewModel: PostViewAdapterDataSource {
  var numberOfItems: Int {
    data.count
  }
  
  func postViewCellItem(at index: Int) -> PostInfo {
    return data[index]
  }

  func contentText(at index: Int) -> String {
    return data[index].content.text
  }
}
