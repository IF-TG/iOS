//
//  PostNestedCommentUpdateRequestDTO.swift
//  travelPlan
//
//  Created by 양승현 on 3/27/24.
//

import Foundation

struct PostNestedCommentUpdateRequestDTO: Decodable {
  let nestedCommentId: Int64
  let comment: String
}
