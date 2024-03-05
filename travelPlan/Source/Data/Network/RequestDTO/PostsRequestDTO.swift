//
//  PostsRequestDTO.swift
//  travelPlan
//
//  Created by 양승현 on 3/6/24.
//

import Foundation

struct PostsRequestDTO: Encodable {
  let page: Int32
  let perPage: Int32
  let orderMethod: String
  let mainCategory: String
  let subCategory: String
  let userId: Int64
}
