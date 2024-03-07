//
//  PostUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 3/6/24.
//

import Combine

protocol PostUseCase {
  var postContainers: PassthroughSubject<[PostContainer], MainError> { get }
  
  func fetchPosts(with page: PostsPage)
}
