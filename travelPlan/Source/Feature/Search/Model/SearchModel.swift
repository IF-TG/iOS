//
//  SearchModel.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/31.
//

import Foundation

enum SearchSection {
  case festival([SearchBestFestivalCellViewModel], SearchHeaderModel)
  case famous([SearchFamousSpotCellViewModel], SearchHeaderModel)
}

extension SearchSection {
  var index: Int {
    switch self {
    case .festival: return 0
    case .famous: return 1
    }
  }
}

struct SearchHeaderModel {
  var title: String
}
