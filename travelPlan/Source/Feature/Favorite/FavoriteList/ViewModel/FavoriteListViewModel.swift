//
//  FavoriteListViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/22.
//

import Foundation

class FavoriteListViewModel {
  // MARK: - Properties
  private var headerData: FavoriteListHeaderModel
  private var cellData: [FavoriteListTableViewCellModel]
  
  // MARK: - Initialization
  init() {
    let mockData = MockFavoriteListdata()
    self.headerData = mockData.mockFavoriteListHeader
    self.cellData = mockData.mockFavoriteListData
  }
}

// MARK: - FavoriteListTableViewAdapterDataSource
extension FavoriteListViewModel: FavoriteListTableViewAdapterDataSource {
  var numberOfItems: Int {
    cellData.count
  }
  
  var headerItem: FavoriteListHeaderModel {
    headerData
  }
  
  func cellItem(at index: Int) -> FavoriteListTableViewCellModel {
    cellData[index]
  }
}
