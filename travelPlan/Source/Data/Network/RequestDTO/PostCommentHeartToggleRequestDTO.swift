//
//  PostCommentHeartToggleRequestDTO.swift
//  travelPlan
//
//  Created by 양승현 on 3/24/24.
//

import Foundation

struct PostCommentHeartToggleRequestDTO: Encodable {
  let id: Int64

  enum CodingKeys: String, CodingKey {
    case id = "objectId"
  }
}
