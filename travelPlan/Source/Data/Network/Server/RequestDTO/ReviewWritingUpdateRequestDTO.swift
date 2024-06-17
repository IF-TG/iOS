//
//  ReviewWritingUpdateRequestDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 4/16/24.
//

import Foundation

struct ReviewWritingUpdateRequestDTO: Encodable {
  let postId: PostIdentifier
  var post: ReviewWritingSaveRequestDTO
}
