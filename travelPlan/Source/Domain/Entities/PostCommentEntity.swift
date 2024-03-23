//
//  PostCommentEntity.swift
//  travelPlan
//
//  Created by 양승현 on 11/10/23.
//

struct PostCommentEntity {
  let commentId: Int64
  let userProfileURL: String
  let userName: String
  let timestamp: String
  let comment: String
  let isDeleted: Bool
  let isOnHeart: Bool
  let isBlocked: Bool
  let hearts: Int32
  let nestedComments: [PostNestedCommentEntity]
}
