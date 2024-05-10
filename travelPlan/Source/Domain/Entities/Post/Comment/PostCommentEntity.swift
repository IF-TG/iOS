//
//  PostCommentEntity.swift
//  travelPlan
//
//  Created by 양승현 on 11/10/23.
//

import Foundation

struct PostCommentEntity {
  let commentId: String
  var authorId: String?
  var userProfileImageData: Data?
  var userName: String
  var timestamp: String
  var comment: String
  var isDeleted: Bool
  var isOnHeart: Bool
  var isBlocked: Bool
  var hearts: Int32
  var nestedComments: [PostNestedCommentEntity]
}
