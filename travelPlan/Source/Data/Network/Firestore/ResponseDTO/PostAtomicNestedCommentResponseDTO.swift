//
//  PostAtomicNestedCommentResponseDTO.swift
//  travelPlan
//
//  Created by 양승현 on 5/8/24.
//

import Foundation

struct PostAtomicNestedCommentResponseDTO: Decodable {
  let nestedCommentId: String
  let authorId: String
  let comment: String
  let createAt: Date
  let hearts: Int
  
  enum CodingKeys: String, CodingKey {
    case nestedCommentId
    case authorId
    case comment
    case createAt
    case hearts = "heartNum"
  }
}
