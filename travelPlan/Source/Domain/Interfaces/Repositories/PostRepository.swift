//
//  PostRepository.swift
//  travelPlan
//
//  Created by 양승현 on 3/7/24.
//

import Combine

protocol PostRepository {
  func fetchPosts(with page: PostsPage) -> Future<Post, MainError>
}
