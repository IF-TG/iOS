//
//  PostUpdatedNestedCommentResponseDTO.swift
//  travelPlan
//
//  Created by 양승현 on 3/27/24.
//

import Foundation

struct PostUpdatedNestedCommentResponseDTO: Decodable {
  let nestedCommentId: NestedCommentIdentifier
  let comment: String
}
