//
//  SearchFestivalModel.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/07/09.
//

import Foundation

// Entity
struct SearchFestivalModel {
  typealias Identifier = Int
  
  let id: Identifier
  let imagePath: String? // Data
  let title: String
  let startDate: Date // Date
  let endDate: Date
  var isSelectedButton: Bool
  let location: String
}

// MARK: - Mock
extension SearchFestivalModel {
  static var mockModels: [SearchFestivalModel] = [
    .init(id: 1, imagePath: "tempThumbnail1", title: "대관령눈꽃축제",
          startDate: Date(), endDate: Date(), isSelectedButton: false, location: "강원도 평창"),
    .init(id: 2, imagePath: "tempThumbnail2", title: "부안붉은노을축제",
          startDate: Date(), endDate: Date(), isSelectedButton: false, location: "전라북도 부안"),
    .init(id: 3, imagePath: "tempThumbnail3", title: "고창갯벌축제",
          startDate: Date(), endDate: Date(), isSelectedButton: false, location: "전라북도 고창"),
    .init(id: 4, imagePath: "tempThumbnail4", title: "축제1",
          startDate: Date(), endDate: Date(), isSelectedButton: false, location: "서울"),
    .init(id: 5, imagePath: "tempThumbnail5", title: "축제1",
          startDate: Date(), endDate: Date(), isSelectedButton: false, location: "서울"),
    .init(id: 6, imagePath: "tempThumbnail6", title: "축제1",
          startDate: Date(), endDate: Date(), isSelectedButton: false, location: "서울"),
    .init(id: 7, imagePath: "tempThumbnail7", title: "축제1",
          startDate: Date(), endDate: Date(), isSelectedButton: false, location: "서울"),
    .init(id: 8, imagePath: "tempThumbnail8", title: "축제1",
          startDate: Date(), endDate: Date(), isSelectedButton: false, location: "서울"),
    .init(id: 9, imagePath: "tempThumbnail9", title: "축제1",
          startDate: Date(), endDate: Date(), isSelectedButton: false, location: "서울")
  ]
}

// MARK: - Public Helpers
extension SearchFestivalModel {
  func makePeriod() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yy.MM.dd"
    
    let startString = dateFormatter.string(from: self.startDate)
    let endString = dateFormatter.string(from: self.endDate)
    
    return startString + "~" + endString
  }
}
