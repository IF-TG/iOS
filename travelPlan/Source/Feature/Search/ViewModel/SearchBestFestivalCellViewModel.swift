//
//  SearchBestFestivalCellViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/07/08.
//

import Foundation

class SearchBestFestivalCellViewModel {
// MARK: - Properties
  var id: Int
  var thumbnailImage: String? // typeFIXME: - URL?
  var title: String
  var periodString: String
  var isSelectedButton: Bool
  
  // MARK: - LifeCycle
  init(model: SearchFestivalModel) {
    id = model.id
    title = model.title
    periodString = model.makePeriod()
    isSelectedButton = model.isSelectedButton
  }
}
