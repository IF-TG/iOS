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
}

// MARK: - Mock
extension SearchFestivalModel {
  static var mockModels: [SearchFestivalModel] = [
    .init(
      id: 1, imagePath: "tempThumbnail7", title: "축제1", startDate: Date(), endDate: Date(), isSelectedButton: false),
    .init(
      id: 2, imagePath: "tempThumbnail7", title: "축제1", startDate: Date(), endDate: Date(), isSelectedButton: false),
    .init(
      id: 3, imagePath: "tempThumbnail7", title: "축제1", startDate: Date(), endDate: Date(), isSelectedButton: false),
    .init(
      id: 4, imagePath: "tempThumbnail7", title: "축제1", startDate: Date(), endDate: Date(), isSelectedButton: false),
    .init(
      id: 5, imagePath: "tempThumbnail7", title: "축제1", startDate: Date(), endDate: Date(), isSelectedButton: false),
    .init(
      id: 6, imagePath: "tempThumbnail7", title: "축제1", startDate: Date(), endDate: Date(), isSelectedButton: false),
    .init(
      id: 7, imagePath: "tempThumbnail7", title: "축제1", startDate: Date(), endDate: Date(), isSelectedButton: false),
    .init(
      id: 8, imagePath: "tempThumbnail7", title: "축제1", startDate: Date(), endDate: Date(), isSelectedButton: false),
    .init(
      id: 9, imagePath: "tempThumbnail7", title: "축제1", startDate: Date(), endDate: Date(), isSelectedButton: false)
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
