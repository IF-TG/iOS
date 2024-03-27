//
//  PostCommentHeartToggleResponseDTO.swift
//  travelPlan
//
//  Created by 양승현 on 3/24/24.
//

import Foundation

struct PostCommentHeartToggleResponseDTO: Decodable {
  let id: Int64
  let isOnHeart: Bool
  
  enum CodingKeys: String, CodingKey {
    case id = "objectId"
    case isOnHeart = "value"
  }
}


// MARK: - Mappings to Domain
extension PostCommentHeartToggleResponseDTO {
  func toDomain() -> ToggledPostCommentHeartEntity {
    return ToggledPostCommentHeartEntity(
      id: id,
      isOnHeart: isOnHeart)
  }
}
