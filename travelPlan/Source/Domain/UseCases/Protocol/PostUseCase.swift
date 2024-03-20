//
//  PostUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 3/6/24.
//

import Combine

struct PostFetchRequestValue {
  let page: Int
  let perPage: Int
  let category: Post.Category
}

protocol PostUseCase {  
  func fetchPosts(with page: PostFetchRequestValue) -> AnyPublisher<[PostContainer], Error>
}
