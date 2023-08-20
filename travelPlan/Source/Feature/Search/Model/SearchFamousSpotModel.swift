//
//  SearchFamousSpotModel.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/07/10.
//

import Foundation

struct SearchFamousSpotModel {
  typealias Identifier = Int
  
  let id: Identifier
  let imageName: String?
  let place: String
  let location: String
  let category: String
  let isSelectedButton: Bool
}

// MARK: - Mock
extension SearchFamousSpotModel {
  static var mockModels: [SearchFamousSpotModel] = [
    .init(id: 1, imageName: "tempProfile4",
          place: "관광 장소명", location: "서울", category: "관광 카테고리", isSelectedButton: false),
    .init(id: 1, imageName: "tempProfile4",
          place: "관광 장소명", location: "서울", category: "관광 카테고리", isSelectedButton: false),
    .init(id: 1, imageName: "tempProfile4",
          place: "관광 장소명", location: "서울", category: "관광 카테고리", isSelectedButton: false),
    .init(id: 1, imageName: "tempProfile4",
          place: "관광 장소명", location: "서울", category: "관광 카테고리", isSelectedButton: false),
    .init(id: 1, imageName: "tempProfile4",
          place: "관광 장소명", location: "서울", category: "관광 카테고리", isSelectedButton: false),
    .init(id: 1, imageName: "tempProfile4",
          place: "관광 장소명", location: "서울", category: "관광 카테고리", isSelectedButton: false)
  ]
}
