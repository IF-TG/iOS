//
//  PostCommentEntity.swift
//  travelPlan
//
//  Created by 양승현 on 11/10/23.
//

struct PostCommentEntity {
  let id: Int64
  let userProfileURL: String
  let userName: String
  let timestamp: String
  let comment: String
  let deleted: Bool
  let isOnHeart: Bool
  let blocked: Bool
  let heartCount: Int32
  let replies: [PostReplyEntity]
}
