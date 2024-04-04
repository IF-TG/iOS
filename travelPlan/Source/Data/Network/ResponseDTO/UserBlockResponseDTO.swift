//
//  UserBlockResponseDTO.swift
//  travelPlan
//
//  Created by 양승현 on 4/1/24.
//

import Foundation

struct UserBlockResponseDTO: Decodable {
  let blockedUserId: Int64
  let isBlocked: Bool
  
  enum CodingKeys: String, CodingKey {
    case blockedUserId = "objectId"
    case isBlocked = "value"
  }
}

// MARK: - Mappings to Domain
extension UserBlockResponseDTO {
  func toDomain() -> BlockedUserIdentifyEntity {
    return .init(userId: blockedUserId, isBlocked: isBlocked)
  }
}
