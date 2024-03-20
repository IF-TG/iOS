//
//  PostUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 3/6/24.
//

import Combine

struct PostFetchRequestValue {
  let page: Int32
  let perPage: Int32
  let category: PostCategory
}

protocol PostUseCase {  
  func fetchPosts(with page: PostFetchRequestValue) -> AnyPublisher<[PostContainer], Error>
}
