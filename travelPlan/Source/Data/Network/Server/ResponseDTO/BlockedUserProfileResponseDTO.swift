//
//  BlockedUserProfileResponseDTO.swift
//  travelPlan
//
//  Created by 양승현 on 4/1/24.
//

import Foundation

struct BlockedUserProfileResponseDTO: Decodable {
  let nickname: String
  let thumbnailURL: String
  
  enum CodingKeys: String, CodingKey {
    case nickname
    case thumbnailURL = "thumbnailUrl"
  }
}
