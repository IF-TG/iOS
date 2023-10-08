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
    .init(id: 1, imagePath: "tempThumbnail8",
          place: "관광 장소명관광 장소명관광 장소명관광 장소명관광 장소명",
          location: "서울서울서울서울서울서울서울서울서울서울서울서울서울서울",
          category: "관광 카테고리관광 카테고리관광 카테고리관광 카테고리관광 카테고리관광 카테고리",
          isSelectedButton: false),
    .init(id: 1, imagePath: "tempThumbnail9",
          place: "관광 장소명", location: "서울", category: "관광 카테고리", isSelectedButton: false),
    .init(id: 1, imagePath: "tempThumbnail10",
          place: "관광 장소명", location: "경기", category: "관광 카테고리", isSelectedButton: false),
    .init(id: 1, imagePath: "tempThumbnail11",
          place: "관광 장소명", location: "인천", category: "관광 카테고리", isSelectedButton: false),
    .init(id: 1, imagePath: "tempThumbnail12",
          place: "관광 장소명", location: "부산", category: "관광 카테고리", isSelectedButton: false),
    .init(id: 1, imagePath: "tempThumbnail13",
          place: "관광 장소명", location: "대구", category: "관광 카테고리", isSelectedButton: false),
    .init(id: 1, imagePath: "tempThumbnail14",
          place: "관광 장소명", location: "경기", category: "관광 카테고리", isSelectedButton: false)
  ]
}
