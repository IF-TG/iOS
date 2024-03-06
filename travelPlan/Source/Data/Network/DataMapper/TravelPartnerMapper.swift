//
//  TravelPartnerMapper.swift
//  travelPlan
//
//  Created by 양승현 on 3/7/24.
//

import Foundation

struct TravelPartnerMapper {
  static func fromDTO(_ dto: String) -> TravelPartner? {
    return switch dto {
    case "ALONE":
        .alone
    case "FAMILY":
        .family
    case "PARENTS":
        .parents
    case "WITH_CHILDREN":
        .children
    case "PARTNER":
        .lover
    case "FRIEND":
        .friend
    case "PET":
        .pet
    default:
      nil
    }
  }
  
  static func toDTO(_ partner: TravelPartner) -> String {
    return switch partner {
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
