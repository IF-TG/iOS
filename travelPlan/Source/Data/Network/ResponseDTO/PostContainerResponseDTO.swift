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
  // FIXME: - 추후 서버에서 페이지 또는 포스트 개수 줄 수 있도록 api수정되면 그에 맞춰 변경해야합니다.
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
    let detail: Post.PostDetail = post.toDomain()
    let author: Post.Author = post.toDomain()
    let post = Post(liked: self.post.liked, detail: detail, author: author)
    return .init(post: post, thumbnail: .init(urls: thumbnails), totalPosts: totalPosts)
  }
}
