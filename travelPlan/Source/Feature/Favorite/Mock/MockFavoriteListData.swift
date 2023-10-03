//
//  MockFavoritedata.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/22.
//

import UIKit

struct MockFavoritedata {
  private let mockProfileImages = [
    UIImage(
      named: "tempThumbnail7")?.compressJPEGImage(with: 0)!,
    UIImage(
      named: "tempThumbnail13")?.compressJPEGImage(with: 0)!]
  
  var mockFavoriteListHeader: FavoriteHeaderView.Model {
    .init(
      categoryCount: 0,
      images: [mockProfileImages[0], mockProfileImages[1]])
  }
  
  var mockFavoriteListData: [FavoriteTableViewCellModel] {
    [FavoriteTableViewCellModel(
      title: "분위기 있는 카페",
      innerItemCount: 0,
      image: mockProfileImages[0]),
     FavoriteTableViewCellModel(
      title: "바다 가즈아~~",
      innerItemCount: 0,
      image: mockProfileImages[1])]
  }
}
