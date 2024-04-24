//
//  PostCommentsRequestDTO.swift
//  travelPlan
//
//  Created by 양승현 on 3/23/24.
//

import Foundation

struct PostCommentsRequestDTO: Encodable {
  let page: Int32
  let perPage: Int32
  let postId: Int64
}
