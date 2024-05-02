//
//  PostNestedCommentHeartToggleRequestDTO.swift
//  travelPlan
//
//  Created by 양승현 on 4/1/24.
//

import Foundation

struct PostNestedCommentHeartToggleRequestDTO: Encodable {
  let id: String
  
  enum CodingKeys: String, CodingKey {
    case id = "objectId"
  }
}
