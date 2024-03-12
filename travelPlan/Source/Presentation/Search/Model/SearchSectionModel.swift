//
//  SearchSectionModel.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/31.
//

import Foundation

struct SearchSectionModel {
  let itemType: SearchItemType
  let headerTitle: String
}

enum SearchItemType {
  case festival([SearchFestivalCellViewModel])
  case camping([TravelDestinationCellViewModel])
  case topTen([SearchTopTenCellViewModel])
}