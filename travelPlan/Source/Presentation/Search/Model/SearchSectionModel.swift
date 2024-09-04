//
//  SearchSectionModel.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/31.
//

import Foundation

struct SearchSectionModel {
  var itemType: SearchSectionType
  let headerTitle: String
}

@frozen enum SearchSectionType {
  case festival([TravelDestinationInfo])
  case leports([TravelDestinationInfo])
  case cultureFacility([TravelDestinationInfo])
  
  func getId(from itemIndex: Int) -> Int {
    switch self {
    case .festival(let infos),
        .leports(let infos),
        .cultureFacility(let infos):
      return infos[itemIndex].id
    }
  }
}

@frozen enum SearchSectionIndex: Int {
  case festival
  case leports
  case cultureFacility
}
