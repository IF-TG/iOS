//
//  StubFavoriteUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/22.
//

import UIKit

struct StubFavoriteUseCase {
  private let profileImageURLs = ["tempThumbnail7", "tempThumbnail13"]
  
  lazy var favoriteHeader: FavoriteAllDirectoryEntity = .init(
    categoryCount: favoriteDirectories.count,
    imageData: [UIImage(named: profileImageURLs[0])!.jpegData(compressionQuality: 1)!,
                UIImage(named: profileImageURLs[1])!.jpegData(compressionQuality: 1)!])
  
  lazy var favoriteDirectories: [FavoriteDirectoryEntity] = [
    .init(title: "분위기 있는 카페", imageThumbnails: [
      UIImage(named: profileImageURLs[0])!.jpegData(compressionQuality: 1)!]),
    .init(title: "벌써 7월? 무더위네!!", imageThumbnails: [
      UIImage(named: profileImageURLs[1])!.jpegData(compressionQuality: 1)!])]
}
