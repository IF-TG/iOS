//
//  PostNestedCommentResponseDTO.swift
//  travelPlan
//
//  Created by 양승현 on 3/23/24.
//

import Foundation

struct PostNestedCommentResponseDTO: Decodable {
  let nestedCommentId: NestedCommentIdentifier
  let userProfileURL: String
  let authorId: UserIdentifier
  let nickname: String
  let timestamp: String
  let comment: String
  let hearts: Int32
  let isOnHeart: Bool
  
  enum CodingKeys: String, CodingKey {
    case nestedCommentId
    case userProfileURL = "profileImgUri"
    // TODO: - 서버에서 authorId추가하면 해당 path로 변환해야합니다.
    case authorId
    case nickname
    case timestamp = "crateAt"
    case comment
    case hearts = "likeNum"
    case isOnHeart = "liked"
  }
  
  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.nestedCommentId = try container.decode(NestedCommentIdentifier.self, forKey: .nestedCommentId)
    self.userProfileURL = try container.decode(String.self, forKey: .userProfileURL)
    self.nickname = try container.decode(String.self, forKey: .nickname)
    self.timestamp = try container.decode(String.self, forKey: .timestamp)
    self.comment = try container.decode(String.self, forKey: .comment)
    self.hearts = try container.decode(Int32.self, forKey: .hearts)
    self.isOnHeart = try container.decode(Bool.self, forKey: .isOnHeart)
    self.authorId = try container.decode(UserIdentifier.self, forKey: .authorId)
  }
}

// MARK: - Mappings to Domain
extension PostNestedCommentResponseDTO {
  func toDomain(with userProfileImageData: Data?) -> PostNestedCommentEntity {
    return PostNestedCommentEntity(
      nestedCommentId: nestedCommentId,
      authorId: authorId,
      userProfileImageData: userProfileImageData,
      nickname: nickname,
      timestamp: timestamp,
      comment: comment,
      hearts: hearts,
      isOnHeart: isOnHeart)
  }
}
