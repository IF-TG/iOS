//
//  FirestorePostCommentSendRequestDTO.swift
//  travelPlan
//
//  Created by 양승현 on 5/4/24.
//

import Foundation
import FirebaseFirestore

struct FirestorePostCommentSendRequestDTO: Encodable {
  let commentId: CommentIdentifier
  let authorId: UserIdentifier
  let createAt: Timestamp
  let comment: String
  let hasDeleted: Bool
  let heartNum: Int
}
