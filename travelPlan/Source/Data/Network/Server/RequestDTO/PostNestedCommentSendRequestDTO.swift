//
//  PostNestedCommentSendRequestDTO.swift
//  travelPlan
//
//  Created by 양승현 on 3/27/24.
//

import Foundation

struct PostNestedCommentSendRequestDTO: Encodable {
  let commentId: Int64
  let comment: String
}
