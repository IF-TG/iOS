//
//  TravelThemeMapper.swift
//  travelPlan
//
//  Created by 양승현 on 3/7/24.
//

import Foundation

struct TravelThemeMapper {
  static func fromDTO(_ dto: String) -> TravelTheme? {
    return switch dto {
    case "REST":
        .relaxation
    case "SHOPPING":
        .shopping
    case "CAMPING_GLAMPING":
        .campingGlamping
    case "ADVENTURE":
        .adventure
    case "LOCAL_EXPERIENCE":
        .local
    case "FESTIVAL":
        .festivals
    default:
      nil
    }
  }
  
  static func toDTO(_ requestValue: TravelTheme) -> String {
    return switch requestValue {
    case .relaxation:
      "REST"
    case .shopping:
      "SHOPPING"
    case .campingGlamping:
      "CAMPING_GLAMPING"
    case .adventure:
      "ADVENTURE"
    case .local:
      "LOCAL_EXPERIENCE"
    case .festivals:
      "FESTIVAL"
    }
  }
}
