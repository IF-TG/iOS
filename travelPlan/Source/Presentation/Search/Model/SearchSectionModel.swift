//
//  SearchSectionModel.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/31.
//

import Foundation

struct SearchSectionModel {
  var itemType: SearchItemType
  let headerTitle: String
}

@frozen enum SearchItemType {
  case festival([SearchFestivalInfo])
  case `else`([TravelDestinationInfo])
  
  func getId(itemIndex: Int) -> Int {
    switch self {
    case .festival(let infos):
      return infos[itemIndex].id
    case .else(let infos):
      return infos[itemIndex].id
    }
  }
}

@frozen enum SearchSectionType: Int {
  case festival
  case leports
  case cultureFacility
}
