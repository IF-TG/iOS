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
    .init(id: 1, imagePath: "tempProfile4",
          place: "관광 장소명관광 장소명관광 장소명관광 장소명관광 장소명",
          location: "서울서울서울서울서울서울서울서울서울서울서울서울서울서울",
          category: "관광 카테고리관광 카테고리관광 카테고리관광 카테고리관광 카테고리관광 카테고리",
          isSelectedButton: false,
          ranking: 10),
    .init(id: 2, imagePath: "tempProfile4",
          place: "관광 장소명", location: "서울", category: "관광 카테고리", isSelectedButton: false, ranking: 9),
    .init(id: 3, imagePath: "tempProfile4",
          place: "관광 장소명", location: "서울", category: "관광 카테고리", isSelectedButton: false, ranking: 8),
    .init(id: 4, imagePath: "tempProfile4",
          place: "관광 장소명", location: "서울", category: "관광 카테고리", isSelectedButton: false, ranking: 7),
    .init(id: 5, imagePath: "tempProfile4",
          place: "관광 장소명", location: "서울", category: "관광 카테고리", isSelectedButton: false, ranking: 6),
    .init(id: 6, imagePath: "tempProfile4",
          place: "관광 장소명", location: "서울", category: "관광 카테고리", isSelectedButton: false, ranking: 5),
    .init(id: 7, imagePath: "tempProfile4",
          place: "관광 장소명", location: "서울", category: "관광 카테고리", isSelectedButton: false, ranking: 4),
    .init(id: 8, imagePath: "tempProfile4",
          place: "관광 장소명", location: "서울", category: "관광 카테고리", isSelectedButton: false, ranking: 3),
    .init(id: 9, imagePath: "tempProfile4",
          place: "관광 장소명", location: "서울", category: "관광 카테고리", isSelectedButton: false, ranking: 2),
    .init(id: 10, imagePath: "tempProfile4",
          place: "관광 장소명", location: "서울", category: "관광 카테고리", isSelectedButton: false, ranking: 1)
  ]
}
