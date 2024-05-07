//
//  PostContainerResponseDTO.swift
//  travelPlan
//
//  Created by 양승현 on 3/6/24.
//

import Foundation

struct PostContainerResponseDTO: Decodable {
  let post: PostResponseDTO
  let thumbnails: [String]
  let totalPosts: Int64

  enum CodingKeys: String, CodingKey {
    case post
    case thumbnails = "thumbnailUri"
    case totalPosts
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.post = try container.decode(PostResponseDTO.self, forKey: .post)
    self.thumbnails = try container.decode([String].self, forKey: .thumbnails)
    self.totalPosts = try container.decode(Int64.self, forKey: .totalPosts)
  }
}

// MARK: - Mappings DTO
extension PostContainerResponseDTO {
  func toDomain() -> PostContainer {
    let post: Post = post.toDomain()
    return .init(post: post, thumbnail: .init(postImageDataList: thumbnails.compactMap { Data(base64Encoded: $0)}), totalPosts: totalPosts)
  }
}
