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
  
  enum CodingKeys: String, CodingKey {
    case post
    case thumbnails = "thumbnailUri"
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.post = try container.decode(PostResponseDTO.self, forKey: .post)
    self.thumbnails = try container.decode([String].self, forKey: .thumbnails)
  }
}

// MARK: - Mappings DTO
extension PostContainerResponseDTO {
  func toDomain() -> PostContainer {
    let detail = post.postDetail.toDomain()
    let author = post.author.toDomain()
    let post = Post(liked: self.post.liked, detail: detail, author: author)
    return .init(post: post, thumbnails: thumbnails)
  }
}
