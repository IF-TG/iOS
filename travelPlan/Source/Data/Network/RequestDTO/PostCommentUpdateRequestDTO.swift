//
//  PostCommentUpdateRequestDTO.swift
//  travelPlan
//
//  Created by 양승현 on 3/24/24.
//

import Foundation

struct PostCommentUpdateRequestDTO: Encodable {
  let commentId: Int64
  let comment: String
}
