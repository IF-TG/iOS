//
//  PostAtomicCommentEntity.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/5/24.
//

import Foundation

struct PostAtomicCommentEntity {
  let commentId: CommentIdentifier
  let authorId: UserIdentifier
  let comment: String
  let createAt: Date
  let hasDeleted: Bool
  let hearts: Int
}
