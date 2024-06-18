//
//  FirestorePostNestedCommentSendRequestDTO.swift
//  travelPlan
//
//  Created by 양승현 on 5/7/24.
//

import Foundation
import FirebaseFirestore

struct FirestorePostNestedCommentSendRequestDTO: Encodable {
  let nestedCommentId: NestedCommentIdentifier
  let authorId: UserIdentifier
  let comment: String
  let hearts: Int
  let createAt: Timestamp
  
  enum CodingKeys: String, CodingKey {
    case nestedCommentId
    case authorId
    case comment
    case hearts = "heartNum"
    case createAt
  }
}
