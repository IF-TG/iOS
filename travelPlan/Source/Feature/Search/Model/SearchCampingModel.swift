//
//  SearchCampingModel.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/07/10.
//

import Foundation

struct SearchCampingModel {
  let id: Int
  let imagePath: String?
  let place: String
  let location: String
  let category: String
  var isSelectedButton: Bool
}

// MARK: - Mock
extension SearchCampingModel {
  static var mockModels: [SearchCampingModel] = [
    .init(id: 1, imagePath: "seoungsimdang",
          place: "성심당",
          location: "대전",
          category: "베이커리",
          isSelectedButton: false),
    .init(id: 1, imagePath: "ockalguksoo",
          place: "오씨칼국수", location: "대전", category: "음식점", isSelectedButton: false),
    .init(id: 1, imagePath: "oncheonjeep",
          place: "온천집", location: "대전", category: "음식점", isSelectedButton: false),
    .init(id: 1, imagePath: "taepyeongsokookbob",
          place: "태평소국밥", location: "대전", category: "음식점", isSelectedButton: false),
    .init(id: 1, imagePath: "tempThumbnail12",
          place: "관광 장소명", location: "부산", category: "관광 카테고리", isSelectedButton: false),
    .init(id: 1, imagePath: "tempThumbnail13",
          place: "관광 장소명", location: "대구", category: "관광 카테고리", isSelectedButton: false),
    .init(id: 1, imagePath: "tempThumbnail14",
          place: "관광 장소명", location: "경기", category: "관광 카테고리", isSelectedButton: false)
  ]
}
