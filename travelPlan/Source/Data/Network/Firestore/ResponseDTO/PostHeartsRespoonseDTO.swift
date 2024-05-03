//
//  PostHeartsRespoonseDTO.swift
//  travelPlan
//
//  Created by 양승현 on 5/3/24.
//

import Foundation

struct PostHeartsRespoonseDTO: Decodable {
  let hearts: Int
  
  enum CodingKeys: String, CodingKey {
    case hearts = "likeNum"
  }
}
