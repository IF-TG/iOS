//
//  PostNestedCommentEntity.swift
//  travelPlan
//
//  Created by 양승현 on 11/10/23.
//

import Foundation

struct PostNestedCommentEntity {
  let nestedCommentId: NestedCommentIdentifier
  let authorId: UserIdentifier
  let userProfileImageData: Data?
  let nickname: String
  var timestamp: String
  var comment: String
  var hearts: Int32
  var isOnHeart: Bool
}
