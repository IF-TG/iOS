//
//  SearchDetailHeaderInfo.swift
//  travelPlan
//
//  Created by SeokHyun on 10/5/23.
//

import Foundation

struct SearchDetailHeaderInfo {
  let title: String
  let imageURL: String?
}

// MARK: - Mock
extension SearchDetailHeaderInfo {
  static let festivalMock = SearchDetailHeaderInfo(title: "베스트 축제 🎡", imageURL: "festival-more")
  //  static let campingMock = SearchDetailHeaderInfo(title: "야영, 레포츠 어떠세요? 🏕️", imageURL: "camping-more")
  static let campingMock = SearchDetailHeaderInfo(title: "대전 맛집", imageURL: "seoungsimdang")
  static let topTenMock = SearchDetailHeaderInfo(title: "여행지 TOP 10 🌟", imageURL: "topten-more")
}
