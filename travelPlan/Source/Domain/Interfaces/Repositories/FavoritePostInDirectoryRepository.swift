//
//  FavoritePostInDirectoryRepository.swift
//  travelPlan
//
//  Created by 양승현 on 4/4/24.
//

import Combine

protocol FavoritePostInDirectoryRepository {
  func fetchFavoritePosts(
    name directoryName: String,
    page: Int32,
    perPage: Int32
  ) -> AnyPublisher<[Post], Error>
  
  func toggleFavoritePost(
    postId: Int64,
    directoryName: String
  ) -> AnyPublisher<FavoritePostToggleEntity, Error>
}
