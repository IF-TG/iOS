//
//  SearchCampingModel.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/07/10.
//

import Foundation

struct SearchCampingModel: TravelDestinationModelable {
  let id: Identifier
  let imagePath: String?
  let place: String
  let location: String
  let category: String
  var isSelectedButton: Bool
}

// MARK: - Mock
extension SearchCampingModel {
  static var mockModels: [SearchCampingModel] = [
    .init(id: 1, imagePath: "tempProfile4",
          place: "관광 장소명관광 장소명관광 장소명관광 장소명관광 장소명",
          location: "서울서울서울서울서울서울서울서울서울서울서울서울서울서울",
          category: "관광 카테고리관광 카테고리관광 카테고리관광 카테고리관광 카테고리관광 카테고리",
          isSelectedButton: false),
    .init(id: 1, imagePath: "tempProfile4",
          place: "관광 장소명", location: "서울", category: "관광 카테고리", isSelectedButton: false),
    .init(id: 1, imagePath: "tempProfile4",
          place: "관광 장소명", location: "서울", category: "관광 카테고리", isSelectedButton: false),
    .init(id: 1, imagePath: "tempProfile4",
          place: "관광 장소명", location: "서울", category: "관광 카테고리", isSelectedButton: false),
    .init(id: 1, imagePath: "tempProfile4",
          place: "관광 장소명", location: "서울", category: "관광 카테고리", isSelectedButton: false),
    .init(id: 1, imagePath: "tempProfile4",
          place: "관광 장소명", location: "서울", category: "관광 카테고리", isSelectedButton: false),
    .init(id: 1, imagePath: "tempProfile4",
          place: "관광 장소명", location: "서울", category: "관광 카테고리", isSelectedButton: false)
  ]
}
