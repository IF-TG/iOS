//
//  TravelTheme+PlanCategorySelectionConfigurable.swift
//  travelPlan
//
//  Created by 양승현 on 6/30/24.
//

import Foundation

extension TravelPartner: PlanCategorySelectionConfigurable {
  var toPlanSelectionCategory: String {
    self.rawValue
  }
}
