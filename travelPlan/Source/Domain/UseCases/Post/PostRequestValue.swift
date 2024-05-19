//
//  RequestValue.swift
//  travelPlan
//
//  Created by 양승현 on 5/16/24.
//

import Foundation

struct PostFetchRequestValue {
  let page: Int32
  let perPage: Int32
  let category: PostCategory
}

struct PostCommentsRequestValue {
  let page: Int32
  let perPage: Int32
  let postId: String
}
