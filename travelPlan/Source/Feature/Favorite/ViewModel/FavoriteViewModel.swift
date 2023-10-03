//
//  FavoriteViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/22.
//

import Foundation

final class FavoriteViewModel {
  // MARK: - Properties
  private var headerData: FavoriteHeaderView.Model
  private var cellData: [FavoriteTableViewCell.Model]
  
  // MARK: - Initialization
  init() {
    let mockData = MockFavoritedata()
    self.headerData = mockData.mockFavoriteListHeader
    self.cellData = mockData.mockFavoriteListData
  }
}

// MARK: - FavoriteListTableViewAdapterDataSource
extension FavoriteViewModel: FavoriteTableViewAdapterDataSource {
  var numberOfItems: Int {
    cellData.count
  }
  
  var headerItem: FavoriteHeaderView.Model {
    headerData
  }
  
  func cellItem(at index: Int) -> FavoriteTableViewCell.Model {
    cellData[index]
  }
}
