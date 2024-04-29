//
//  FirestoreReviewWritingSaveRequestDTO.swift
//  travelPlan
//
//  Created by 양승현 on 4/29/24.
//

import Foundation

struct FirestoreReviewWritingSaveRequestDTO: Encodable {
  var reviewWritingSaveRequestDTO: ReviewWritingSaveRequestDTO
  let postId: String
  
  let authorId: String
  
  let likeNum: Int = 0
  let createAt: String
  
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
  }
}

extension FirestoreReviewWritingSaveRequestDTO {
  static func makeRequestDTO(
    entity: ReviewWritingEntity,
    postId: String,
    authorId: String
  ) -> Self {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy.MM.dd"
    let curDate = Date()
    let curDateString = formatter.string(from: curDate)
    return .init(
      reviewWritingSaveRequestDTO: ReviewWritingSaveRequestDTO.makeRequestDTO(entity: entity),
      postId: postId,
      authorId: authorId,
      createAt: curDateString)
  }
}
