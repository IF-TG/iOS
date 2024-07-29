//
//  DestinationLikeResponseDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 7/24/24.
//

import Foundation

struct DestinationLikeResponseDTO: Decodable {
  let objectId: Int
  let value: Bool
}

// MARK: - Mapping to Domain
extension DestinationLikeResponseDTO {
  func toDomain() -> DestinationLike {
    return .init(id: objectId, isSelected: value)
  }
}
