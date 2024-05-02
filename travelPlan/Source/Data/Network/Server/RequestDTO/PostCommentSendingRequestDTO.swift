//
//  PostCommentSendingRequestDTO.swift
//  travelPlan
//
//  Created by 양승현 on 3/23/24.
//

import Foundation

struct PostCommentSendingRequestDTO: Encodable {
  let postId: String
  let comment: String
}
