//
//  SearchFestivalModel.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/07/09.
//

import Foundation

struct SearchFestivalModel {
  typealias Identifier = Int
  
  let id: Identifier
  let imageName: String? // Data
  let title: String
  let startDate: Date // Date
  let endDate: Date
  let isSelectedButton: Bool
}

// MARK: - Mock
extension SearchFestivalModel {
  static var models: [SearchFestivalModel] = [
    .init(
      id: 1, imageName: "tempThumbnail7", title: "축제1", startDate: Date(), endDate: Date(), isSelectedButton: false),
    .init(
      id: 2, imageName: "tempThumbnail7", title: "축제1", startDate: Date(), endDate: Date(), isSelectedButton: false),
    .init(
      id: 3, imageName: "tempThumbnail7", title: "축제1", startDate: Date(), endDate: Date(), isSelectedButton: false),
    .init(
      id: 4, imageName: "tempThumbnail7", title: "축제1", startDate: Date(), endDate: Date(), isSelectedButton: false)
  ]
}

// MARK: - Public Helpers
extension SearchFestivalModel {
  func makePeriod() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy.MM.dd"
    let startString = dateFormatter.string(from: self.startDate)
    let endString = dateFormatter.string(from: self.endDate)
    
    return startString + "~" + endString
  }
}
