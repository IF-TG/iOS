//
//  TravelPartner.swift
//  travelPlan
//
//  Created by 양승현 on 2023/09/13.
//

import Foundation

enum TravelPartner: String, CaseIterable {
  case alone = "혼자"
  case family = "가족과 함께"
  case parents = "부모님과 함께"
  case children = "아이들과 함께"
  case lover = "연인과 함께"
  case friend = "친구와 함께"
  case pet = "애완견과 함게"
}

// MARK: - Mappings toDTO
extension TravelPartner {
  func toDTO() -> String {
    return switch self {
    case .alone:
      "ALONE"
    case .family:
      "FAMILY"
    case .parents:
      "PARENTS"
    case .children:
      "WITH_CHILDREN"
    case .lover:
      "PARTNER"
    case .friend:
      "FRIEND"
    case .pet:
      "PET"
    }
  }
}
