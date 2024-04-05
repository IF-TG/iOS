//
//  PostCommentEntity.swift
//  travelPlan
//
//  Created by 양승현 on 11/10/23.
//

struct PostCommentEntity {
  let commentId: Int64
  var userProfileURL: String
  var userName: String
  var timestamp: String
  var comment: String
  var isDeleted: Bool
  var isOnHeart: Bool
  var isBlocked: Bool
  var hearts: Int32
  var nestedComments: [PostNestedCommentEntity]
}
