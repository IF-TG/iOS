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
          place: "태평소국밥", location: "대전", category: "음식점", isSelectedButton: true),
    .init(id: 1, imagePath: "seomun",
          place: "서문애수육국밥", location: "대전", category: "음식점", isSelectedButton: false),
    .init(id: 1, imagePath: "chiangmai",
          place: "치앙마이방콕", location: "대전", category: "음식점", isSelectedButton: true),
    .init(id: 1, imagePath: "taehwajang",
          place: "태화장", location: "대전", category: "음식점", isSelectedButton: false)
  ]
}
