//
//  PostFetchUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 5/15/24.
//

import Foundation
import Combine

protocol PostFetchUseCase {
  func fetchFilteredPosts(
    with page: PostFetchRequestValue
  ) -> AnyPublisher<PostsPage, Error>
  
  func fetchPost(with postId: PostIdentifier) -> AnyPublisher<Post, Error>
}
