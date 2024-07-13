//
//  PostRepository.swift
//  travelPlan
//
//  Created by 양승현 on 3/7/24.
//

import Combine

protocol PostRepository {
  func fetchPosts(
    page: Int32,
    perPage: Int32,
    category: PostCategory
  ) -> AnyPublisher<PostsPage, Error>
  
  func fetchComments(
    page: Int32,
    perPage: Int32,
    postId: Int64
  ) -> AnyPublisher<PostCommentContainerEntity, Error>
  
  func fetchLikedPostsByLoggedInUser(
    page: Int32,
    perPage: Int32
  ) -> AnyPublisher<PostsPage, Error>
  
  func searchPosts(
    keyword: String,
    page: Int32,
    perPage: Int32,
    isTitle: Bool,
    isContent: Bool
  ) -> AnyPublisher<[Post], Error>
  
  func togglePostHeart(postId: Int64) -> AnyPublisher<Bool, Error>
}
