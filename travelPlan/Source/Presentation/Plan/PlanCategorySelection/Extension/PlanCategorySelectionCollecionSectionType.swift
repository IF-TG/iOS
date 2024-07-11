//
//  PlanCategorySelectionCollecionSectionType.swift
//  travelPlan
//
//  Created by 양승현 on 6/30/24.
//

import Foundation
extension PlanCategorySelectionViewController {
  @frozen enum SectionType: Int, CaseIterable {
    case region = 0
    case partner = 1
    case theme = 2
    
    var numberOfItems: Int {
      switch self {
      case .region:
        TravelRegion.count
      case .partner:
        TravelPartner.count
      case .theme:
        TravelTheme.count
      }
    }
    
    static func toSectionType(indexPath: IndexPath) -> SectionType? {
      switch indexPath.section {
      case 0:
        return .region
      case 1:
        return .partner
      case 2:
        return .theme
      default:
        return nil
      }
    }
  }
}
