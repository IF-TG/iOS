//
//  PostRepository.swift
//  travelPlan
//
//  Created by 양승현 on 3/7/24.
//

import Combine

protocol PostRepository {
  func fetchPosts(page: Int32, perPage: Int32, category: PostsPage.Category) -> Future<[PostContainer], Error>
}
