//
//  FirestoreReviewWritingSaveRequestDTO.swift
//  travelPlan
//
//  Created by 양승현 on 4/29/24.
//

import Foundation
import Firebase

struct FirestoreReviewWritingSaveRequestDTO: Encodable {
  var reviewWritingSaveRequestDTO: ReviewWritingSaveRequestDTO
  let postId: String
  
  let authorId: String
  
  let likeNum: Int = 0
  let createAt: Timestamp
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(reviewWritingSaveRequestDTO, forKey: .reviewWritingSaveRequestDTO)
    try container.encode(postId, forKey: .postId)
    try container.encode(authorId, forKey: .authorId)
    try container.encode(likeNum, forKey: .likeNum)
    try container.encode(createAt, forKey: .createAt)
  }
  
  enum CodingKeys: String, CodingKey {
    case reviewWritingSaveRequestDTO
    case postId
    case authorId
    case likeNum
    case createAt
    case title
    case content
    case startDate
    case endDate
    case themes
    case regions
    case seasons
    case companions
    case imgFileList
    case mapX
    case mapY

  }
}

extension FirestoreReviewWritingSaveRequestDTO {
  static func makeRequestDTO(
    entity: ReviewWritingEntity,
    postId: String,
    authorId: String
  ) -> Self {
    return .init(
      reviewWritingSaveRequestDTO: ReviewWritingSaveRequestDTO.makeRequestDTO(entity: entity),
      postId: postId,
      authorId: authorId,
      createAt: Timestamp(date: Date()))
  }
}
