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
  ) -> Future<PostsPage, Error>
  
  func fetchComments(
    page: Int32,
    perPage: Int32,
    postId: Int64
  ) -> Future<PostCommentContainerEntity, Error>
}
