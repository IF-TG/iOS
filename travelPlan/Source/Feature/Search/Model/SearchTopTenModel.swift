//
//  SearchTopTenModel.swift
//  travelPlan
//
//  Created by SeokHyun on 10/7/23.
//

import Foundation

struct SearchTopTenModel {
  typealias Identifier = Int
  
  let id: Identifier
  let imagePath: String?
  let place: String
  let location: String
  let category: String
  var isSelectedButton: Bool
  
  let ranking: Int
}

extension SearchTopTenModel {
  static var mockModels: [SearchTopTenModel] = [
    .init(id: 1, imagePath: "tempThumbnail6",
          place: "관광 장소명관광 장소명관광 장소명관광 장소명관광 장소명",
          location: "서울서울서울서울서울서울서울서울서울서울서울서울서울서울",
          category: "관광 카테고리관광 카테고리관광 카테고리관광 카테고리관광 카테고리관광 카테고리",
          isSelectedButton: false,
          ranking: 10),
    .init(id: 2, imagePath: "tempThumbnail15",
          place: "관광 장소명", location: "서울", category: "관광 카테고리", isSelectedButton: false, ranking: 9),
    .init(id: 3, imagePath: "tempThumbnail15",
          place: "관광 장소명", location: "서울", category: "관광 카테고리", isSelectedButton: false, ranking: 8),
    .init(id: 4, imagePath: "tempThumbnail15",
          place: "관광 장소명", location: "서울", category: "관광 카테고리", isSelectedButton: false, ranking: 7),
    .init(id: 5, imagePath: "tempThumbnail15",
          place: "관광 장소명", location: "서울", category: "관광 카테고리", isSelectedButton: false, ranking: 6),
    .init(id: 6, imagePath: "tempThumbnail15",
          place: "관광 장소명", location: "서울", category: "관광 카테고리", isSelectedButton: false, ranking: 5),
    .init(id: 7, imagePath: "tempThumbnail15",
          place: "관광 장소명", location: "서울", category: "관광 카테고리", isSelectedButton: false, ranking: 4),
    .init(id: 8, imagePath: "tempThumbnail14",
          place: "관광 장소명", location: "서울", category: "관광 카테고리", isSelectedButton: false, ranking: 3),
    .init(id: 9, imagePath: "tempThumbnail13",
          place: "관광 장소명", location: "서울", category: "관광 카테고리", isSelectedButton: false, ranking: 2),
    .init(id: 10, imagePath: "tempThumbnail12",
          place: "관광 장소명", location: "서울", category: "관광 카테고리", isSelectedButton: false, ranking: 1)
  ]
}
