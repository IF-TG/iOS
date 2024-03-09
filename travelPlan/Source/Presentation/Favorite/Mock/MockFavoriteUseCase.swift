//
//  MockFavoriteUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/22.
//

import UIKit

struct MockFavoriteUseCase {
  private let profileImageURLs = ["tempThumbnail7", "tempThumbnail13"]
  
  lazy var favoriteHeader: FavoriteHeaderDirectoryEntity = .init(
    categoryCount: favoriteDirectories.count,
    imageURLs: profileImageURLs)
  
  lazy var favoriteDirectories: [FavoriteDirectoryEntity] = [
    .init(id: 0, title: "분위기 있는 카페", innerItemCount: 0, imageURL: profileImageURLs[0]),
    .init(id: 1, title: "벌써 10월이야? 단풍 명소~", innerItemCount: 1, imageURL: profileImageURLs[1])]
}
