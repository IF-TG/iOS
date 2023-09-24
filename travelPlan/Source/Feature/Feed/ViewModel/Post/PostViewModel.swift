//
//  PostViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/14.
//

import Foundation

final class PostViewModel {
  // MARK: - Properties
  private let data: [PostModel] = MockPostModel().initMockData()
  
  private(set) var travelTheme: TravelThemeType = .all
  
  private(set) var travelTrend: TravelTrend = .newest
  
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
  func cellItem(_ indexPath: IndexPath) -> PostModel {
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
  
  func postViewCellItem(at index: Int) -> PostModel {
    return data[index]
  }

  func contentText(at index: Int) -> String {
    return data[index].content.text
  }
}
