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
  case festival([SearchBestFestivalCellViewModel])
  case famous([TravelDestinationCellViewModel])
}

/// headerView를 재사용하기 때문에 type을 구분지어주기 위해 필요합니다.
enum SearchSectionType: Int {
  case festival
  case famous
}
