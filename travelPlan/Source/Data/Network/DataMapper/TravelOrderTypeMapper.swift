//
//  TravelOrderTypeMapper.swift
//  travelPlan
//
//  Created by 양승현 on 3/7/24.
//

import Foundation

struct TravelOrderTypeMapper {
  static func fromDTO(_ dto: String) -> TravelOrderType? {
    return switch dto {
    case "RECENT_ORDER":
        .newest
    case "RECOMMEND_ORDER":
        .popularity
    default:
      nil
    }
  }
  
  static func toDTO(_ theme: TravelOrderType) -> String {
    return switch theme {
    case .newest:
      "RECENT_ORDER"
    case .popularity:
      "RECOMMEND_ORDER"
    }
  }
}
