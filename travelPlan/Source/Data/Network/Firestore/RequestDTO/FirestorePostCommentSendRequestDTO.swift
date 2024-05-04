//
//  FirestorePostCommentSendRequestDTO.swift
//  travelPlan
//
//  Created by 양승현 on 5/4/24.
//

import Foundation
import FirebaseFirestore

struct FirestorePostCommentSendRequestDTO: Encodable {
  let commentId: String
  let authorId: String
  let createAt: Timestamp
  let comment: String
  let hasBlocked: Bool
  let hasDeleted: Bool
  let heartNum: Int
}
