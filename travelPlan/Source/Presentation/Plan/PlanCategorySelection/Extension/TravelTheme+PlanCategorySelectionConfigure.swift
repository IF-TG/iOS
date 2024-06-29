//
//  TravelTheme+PlanCategoryConfigure.swift
//  travelPlan
//
//  Created by 양승현 on 6/30/24.
//

import Foundation

// MARK: SOLID OCP 느낌으로다가.. 기존 layer Entity에는 변화 x
extension TravelTheme: PlanCategorySelectionConfigurable {
  var toPlanSelectionCategory: String {
    let icon: String = switch self {
    case .relaxation: "🍃"
    case .shopping: "🛍️"
    case .campingGlamping: "⛺"
    case .adventure: "🔦"
    case .local: "🪁"
    case .festivals: "🎉"
    }
    return "\(icon) \(self.rawValue)"
  }
}
