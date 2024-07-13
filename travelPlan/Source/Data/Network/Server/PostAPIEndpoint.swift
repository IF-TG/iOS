//
//  PostAPIEndpoint.swift
//  travelPlan
//
//  Created by 양승현 on 3/7/24.
//

import Foundation

struct PostAPIEndpoint {
  static func fetchPosts(
    with requestDTO: PostsRequestDTO
  ) -> Endpoint<CommonDTO<[PostContainerResponseDTO]>> {
    return Endpoint(
      scheme: "http",
      host: "localhost:8080",
      method: .get,
      parameters: [.query(requestDTO)],
      requestType: .post(.postsFetch))
  }
  
  static func fetchComments(
    with requestDTO: PostCommentsRequestDTO
  ) -> Endpoint<CommonDTO<PostCommentContainerResponseDTO>> {
    return Endpoint(
      scheme: "http",
      host: "localhost:8080",
      method: .get,
      parameters: [.query(requestDTO)],
      requestType: .post(.postCommentsFetch))
  }
  
  static func fetchLikedPostsByLoggedInUser(
    wtih requestDTO: LikedPostsByLoggedInUserRequestDTO
  ) -> Endpoint<CommonDTO<[PostContainerResponseDTO]>> {
    return Endpoint(
      scheme: "http",
      host: "localhost:8080",
      method: .get,
      parameters: [.query(requestDTO)],
      requestType: .post(.likedPostsByLoggedInUserFetch))
  }
  
  static func searchPosts(
    with requestDTO: PostSearchRequestDTO
  ) -> Endpoint<CommonDTO<[PostResponseDTO]>> {
    return Endpoint(
      scheme: "http",
      host: "localhost:8080",
      method: .get,
      parameters: [.query(requestDTO)],
      requestType: .post(.postSearch))
  }
  
  static func togglePostLike(
    with requestDTO: PostCommentHeartToggleRequestDTO
  ) -> Endpoint<CommonDTO<PostCommentHeartToggleResponseDTO>> {
    return Endpoint(
      host: "localhost:8080",
      method: .post,
      parameters: [.body(requestDTO)],
      requestType: .post(.toggleLike))
  }
}
