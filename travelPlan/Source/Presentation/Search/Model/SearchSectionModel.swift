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

enum SearchItemType {
  
  case festival([SearchFestivalInfo])
//  case camping([TravelDestinationItemInfo])
//  case cultureFacility
  case leports([TravelDestinationItemInfo])
//  case sessionalRecommendation
}
