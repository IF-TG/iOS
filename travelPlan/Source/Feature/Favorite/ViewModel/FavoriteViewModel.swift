//
//  FavoriteViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/22.
//

import Foundation

// 임시
struct FavoriteHeaderDirectoryEntity {
  let categoryCount: Int
  let imageURLs: [String?]
}

struct FavoriteDirectoryEntity {
  let id: Int
  let title: String
  let innerItemCount: Int
  let imageURL: String?
}

final class FavoriteViewModel {
  // MARK: - Dependencies
  
  // MARK: - Properties
  private var headerDirectory: FavoriteHeaderDirectoryEntity
  private var favoriteDirectories: [FavoriteDirectoryEntity]
  
  // MARK: - Lifecycles
  init() {
    var mockData = MockFavoriteUseCase()
    headerDirectory = mockData.favoriteHeader
    favoriteDirectories = mockData.favoriteDirectories
  }
}

// MARK: - FavoriteListTableViewAdapterDataSource
extension FavoriteViewModel: FavoriteTableViewAdapterDataSource {
  var numberOfItems: Int {
    favoriteDirectories.count
  }
  
  var headerItem: FavoriteHeaderView.Model {
    return .init(categoryCount: headerDirectory.categoryCount, imageURLs: headerDirectory.imageURLs)
  }
  
  func cellItem(at index: Int) -> FavoriteTableViewCell.Model {
    let item = favoriteDirectories[index]
    return .init(title: item.title, innerItemCount: item.innerItemCount, imageURL: item.imageURL)
  }
}
