//
//  FavoritePostDirectoryNameUpdateResponseDTO.swift
//  travelPlan
//
//  Created by 양승현 on 4/5/24.
//

import Foundation

struct FavoritePostDirectoryNameUpdateResponseDTO: Decodable {
  let postId: Int64
  let userId: Int64
  let directoryName: String
  
  enum CodingKeys: String, CodingKey {
    case postId = "objectId"
    case userId = "userId"
    case directoryName = "folderName"
  }
}
