//
//  MockFavoriteListData.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/22.
//

import UIKit

struct MockFavoriteListdata {
  private let mockProfileImages = [
    UIImage(
      named: "tempThumbnail7")?.compressJPEGImage(with: 0)!,
    UIImage(
      named: "tempThumbnail13")?.compressJPEGImage(with: 0)!]
  
  var mockFavoriteListHeader: FavoriteListHeaderModel {
    FavoriteListHeaderModel(
      categoryCount: 0,
      images: [mockProfileImages[0], mockProfileImages[1]])
  }
  
  var mockFavoriteListData: [FavoriteListTableViewCellModel] {
    [FavoriteListTableViewCellModel(
      title: "분위기 있는 카페",
      innerItemCount: 0,
      image: mockProfileImages[0]),
     FavoriteListTableViewCellModel(
      title: "바다 가즈아~~",
      innerItemCount: 0,
      image: mockProfileImages[1])]
  }
}
