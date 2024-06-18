//
//  PostAtomicNestedCommentEntity.swift
//  travelPlan
//
//  Created by 양승현 on 5/7/24.
//

import Foundation

struct PostAtomicNestedCommentEntity {
  let nestedCommentId: NestedCommentIdentifier
  let authorId: UserIdentifier
  let comment: String
  let createAt: Date
  let hearts: Int
}
