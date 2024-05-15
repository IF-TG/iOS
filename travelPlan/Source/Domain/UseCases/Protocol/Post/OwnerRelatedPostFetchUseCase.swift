//
//  OwnerRelatedPostFetchUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 5/15/24.
//

import Foundation
import Combine

protocol OwnerRelatedPostFetchUseCase {
  func fetchOwnerLikedPosts(
    page: Int32,
    perIage: Int32
  ) -> AnyPublisher<PostsPage, Error>
  
  func fetchOwnerWrotePosts(
    isFirstPage: Bool,
    perPage: Int32
  ) -> AnyPublisher<PostsPage, any Error>
}
