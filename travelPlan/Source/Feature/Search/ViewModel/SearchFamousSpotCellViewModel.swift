//
//  SearchFamousSpotCellViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/07/10.
//

import Foundation

class SearchFamousSpotCellViewModel {
  let id: Int
  let thumbnailImage: String? // typeFIXME: - URL?
  let place: String
  let location: String
  let category: String
  let isSelectedButton: Bool
  
  init(model: SearchFamousSpotModel) {
    self.id = model.id
    self.thumbnailImage = model.imageName
    self.location = model.location
    self.category = model.category
    self.place = model.place
    self.isSelectedButton = model.isSelectedButton
  }
  
  deinit {
    print("deinit SearchFamousSpotCellViewModel")
  }
}
