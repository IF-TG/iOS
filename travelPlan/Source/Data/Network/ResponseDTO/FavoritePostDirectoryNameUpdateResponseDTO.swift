//
//  FavoritePostDirectoryNameUpdateResponseDTO.swift
//  travelPlan
//
//  Created by 양승현 on 4/5/24.
//

import Foundation

struct FavoritePostDirectoryNameUpdateResponseDTO: Decodable {
  let directoryId: Int64
  let userId: Int64
  let directoryName: String
  
  enum CodingKeys: String, CodingKey {
    case directoryId = "objectId"
    case userId = "userId"
    case directoryName = "folderName"
  }
}

// MARK: - Mappings to Domain
extension FavoritePostDirectoryNameUpdateResponseDTO {
  func toDomain() -> UpdatedFavoritePostDirectoryName {
    return .init(directoryId: directoryId, userId: userId, directoryname: directoryName)
  }
}
