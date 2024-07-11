//
//  DestinationScrapUpdateResponseDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 7/12/24.
//

import Foundation

struct DestinationScrapUpdateResponseDTO: Decodable {
  let scrapId: Int64
  let userId: Int64
  let folderName: String
  
  private enum CodingKeys: String, CodingKey {
    case scrapId = "objectId"
    case userId
    case folderName
  }
}

// MARK: - Mapping Domain
extension DestinationScrapUpdateResponseDTO {
  func toDomain() -> UpdatedDestinationScrap {
    return .init(scrapId: scrapId, userId: userId, folderName: folderName)
  }
}
