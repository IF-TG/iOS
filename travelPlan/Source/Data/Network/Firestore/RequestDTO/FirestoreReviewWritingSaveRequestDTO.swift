//
//  FirestoreReviewWritingSaveRequestDTO.swift
//  travelPlan
//
//  Created by 양승현 on 4/29/24.
//

import Foundation
import FirebaseFirestore

struct FirestoreReviewWritingSaveRequestDTO: Encodable {
  var reviewWritingSaveRequestDTO: ReviewWritingSaveRequestDTO
  let postId: PostIdentifier
  let authorId: UserIdentifier
  let likeNum: Int = 0
  let commentNum: Int = 0
  let createAt: Timestamp
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(reviewWritingSaveRequestDTO.companions, forKey: .companions)
    try container.encode(reviewWritingSaveRequestDTO.content, forKey: .contents)
    try container.encode(reviewWritingSaveRequestDTO.endDate, forKey: .endDate)
    try container.encode(reviewWritingSaveRequestDTO.imgFileList, forKey: .imgFileList)
    try container.encode(reviewWritingSaveRequestDTO.mapX, forKey: .mapX)
    try container.encode(reviewWritingSaveRequestDTO.mapY, forKey: .mapY)
    try container.encode(reviewWritingSaveRequestDTO.regions, forKey: .regions)
    try container.encode(reviewWritingSaveRequestDTO.seasons, forKey: .seasons)
    try container.encode(reviewWritingSaveRequestDTO.startDate, forKey: .startDate)
    try container.encode(reviewWritingSaveRequestDTO.themes, forKey: .themes)
    try container.encode(reviewWritingSaveRequestDTO.title, forKey: .title)
    try container.encode(postId, forKey: .postId)
    try container.encode(authorId, forKey: .authorId)
    try container.encode(likeNum, forKey: .likeNum)
    try container.encode(commentNum, forKey: .commentNum)
    try container.encode(createAt, forKey: .createAt)
    try container.encode(commentNum, forKey: .commentNum)
  }
  
  enum CodingKeys: String, CodingKey {
    case postId
    case authorId
    case likeNum
    case commentNum
    case createAt
    case title
    case contents
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
    postId: PostIdentifier,
    authorId: UserIdentifier
  ) -> Self {
    return .init(
      reviewWritingSaveRequestDTO: ReviewWritingSaveRequestDTO.makeRequestDTO(entity: entity),
      postId: postId,
      authorId: authorId,
      createAt: Timestamp(date: Date()))
  }
}
