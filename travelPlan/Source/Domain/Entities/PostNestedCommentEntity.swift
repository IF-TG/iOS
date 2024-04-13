//
//  PostNestedCommentEntity.swift
//  travelPlan
//
//  Created by 양승현 on 11/10/23.
//

struct PostNestedCommentEntity {
  let nestedCommentId: Int64
  let userProfileURL: String
  let nickname: String
  var timestamp: String
  var comment: String
  var hearts: Int32
  var isOnHeart: Bool
}
