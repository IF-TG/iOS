//
//  SearchTop10Model.swift
//  travelPlan
//
//  Created by SeokHyun on 10/7/23.
//

import Foundation

struct SearchTop10Model {
  typealias Identifier = Int
  
  let id: Identifier
  let imageURLString: String?
  let place: String
  let location: String
  let category: String
  var isSelectedButton: Bool
}

extension SearchTop10Model {
  static var mockModels: [SearchTop10Model] = [
    .init(id: 1, imageURLString: "tempProfile4",
          place: "관광 장소명관광 장소명관광 장소명관광 장소명관광 장소명",
          location: "서울서울서울서울서울서울서울서울서울서울서울서울서울서울",
          category: "관광 카테고리관광 카테고리관광 카테고리관광 카테고리관광 카테고리관광 카테고리",
          isSelectedButton: false),
    .init(id: 2, imageURLString: "tempProfile4",
          place: "관광 장소명", location: "서울", category: "관광 카테고리", isSelectedButton: false),
    .init(id: 3, imageURLString: "tempProfile4",
          place: "관광 장소명", location: "서울", category: "관광 카테고리", isSelectedButton: false),
    .init(id: 4, imageURLString: "tempProfile4",
          place: "관광 장소명", location: "서울", category: "관광 카테고리", isSelectedButton: false),
    .init(id: 5, imageURLString: "tempProfile4",
          place: "관광 장소명", location: "서울", category: "관광 카테고리", isSelectedButton: false),
    .init(id: 6, imageURLString: "tempProfile4",
          place: "관광 장소명", location: "서울", category: "관광 카테고리", isSelectedButton: false),
    .init(id: 7, imageURLString: "tempProfile4",
          place: "관광 장소명", location: "서울", category: "관광 카테고리", isSelectedButton: false)
  ]
}
