//
//  FavoritePostScrapResponseDTO.swift
//  travelPlan
//
//  Created by 양승현 on 4/5/24.
//

import Foundation

struct FavoritePostScrapResponseDTO: Decodable {
  let postId: Int64
  let isScrapped: Bool
  
  enum CodingKeys: String, CodingKey {
    case postId = "objectId"
    case isScrapped = "value"
  }
}
