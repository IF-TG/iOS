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
  
  func toModel() -> FavoriteHeaderView.Model {
    return .init(categoryCount: self.categoryCount, imageURLs: self.imageURLs)
  }
}

struct FavoriteDirectoryEntity {
  let id: Int
  let title: String
  let innerItemCount: Int
  let imageURL: String?
  
  func toModel() -> FavoriteTableViewCell.Model {
    return .init(
      title: self.title,
      innerItemCount: self.innerItemCount,
      imageURL: self.imageURL)
  }
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
    headerDirectory.toModel()
  }
  
  func cellItem(at index: Int) -> FavoriteTableViewCell.Model {
    return favoriteDirectories[index].toModel()
  }
}
