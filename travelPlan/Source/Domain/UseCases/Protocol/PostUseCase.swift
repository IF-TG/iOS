//
//  PostUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 3/6/24.
//

import Combine

protocol PostUseCase {  
  func fetchPosts(with page: PostsPage) -> AnyPublisher<[PostContainer], Error>
}
