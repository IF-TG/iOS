//
//  FirestorePostCommentResponseDTO.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/5/24.
//

import Foundation
import FirebaseFirestore

struct FirestorePostCommentResponseDTO: Decodable {
  let authorId: String
  let commentId: String
  let comment: String
  let createAt: Timestamp
  let hasDeleted: Bool
  let heartNum: Int
}
