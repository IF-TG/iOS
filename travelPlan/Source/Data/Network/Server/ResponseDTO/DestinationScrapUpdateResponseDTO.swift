//
//  DestinationScrapUpdateResponseDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 7/12/24.
//

import Foundation

struct DestinationScrapUpdateResponseDTO: Decodable {
  let id: Int64
  let userId: Int64
  let folderName: String
  
  private enum CodingKeys: String, CodingKey {
    case id = "objectId"
    case userId
    case folderName
  }
}

// MARK: - Mapping Domain
extension DestinationScrapUpdateResponseDTO {
  func toDomain() -> UpdatedDestinationScrap {
    return .init(id: id, userId: userId, folderName: folderName)
  }
}
