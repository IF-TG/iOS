//
//  DestinationScrapToggleResponseDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 6/30/24.
//

import Foundation

struct DestinationScrapToggleResponseDTO: Decodable {
  let scrapId: Int64
  let isSelected: Bool
  
  private enum CodingKeys: String, CodingKey {
    case isSelected = "value"
    case scrapId = "objectId"
  }
}

extension DestinationScrapToggleResponseDTO {
  func toDomain() -> DestinationScrapToggler {
    return .init(id: scrapId, isSelected: isSelected)
  }
}
