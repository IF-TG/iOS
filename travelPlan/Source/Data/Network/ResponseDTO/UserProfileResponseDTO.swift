//
//  UserProfileResponseDTO.swift
//  travelPlan
//
//  Created by 양승현 on 3/3/24.
//

import Foundation

struct UserProfileResponseDTO: Decodable {
  let imageURL: String
  let userID: String
  
  enum CodingKeys: String, CodingKey {
    case imageURL = "imageUrl"
    case userID = "userId"
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.imageURL = try container.decode(String.self, forKey: .imageURL)
    self.userID = try container.decode(String.self, forKey: .userID)
  }
}
