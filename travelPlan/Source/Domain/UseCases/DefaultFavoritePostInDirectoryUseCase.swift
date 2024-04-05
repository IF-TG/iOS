//
//  DefaultFavoritePostInDirectoryUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 4/4/24.
//

import Foundation
import Combine

final class DefaultFavoritePostInDirectoryUseCase {
  // MARK: - Dependencies
  private let favoritePostInDirectoryRepository: FavoritePostInDirectoryRepository
  
  private let backgroundQueue: DispatchQueue
  
  // MARK: - Lifecycle
  init(
    favoritePostInDirectoryRepository: FavoritePostInDirectoryRepository,
    backgroundQueue: DispatchQueue = .global(qos: .default)
  ) {
    self.favoritePostInDirectoryRepository = favoritePostInDirectoryRepository
    self.backgroundQueue = backgroundQueue
  }
}

// MARK: - FavoritePostInDirectoryUseCase
extension DefaultFavoritePostInDirectoryUseCase: FavoritePostInDirectoryUseCase {
  func fetchFavoritePosts(
    name directoryName: String,
    page: Int32, perPage: Int32
  ) -> AnyPublisher<[Post], any Error> {
    return favoritePostInDirectoryRepository
      .fetchFavoritePosts(name: directoryName, page: page, perPage: perPage)
      .subscribe(on: backgroundQueue)
      .eraseToAnyPublisher()
  }
  
  func toggleFavoritePost(
    postId: Int64, 
    directoryName: String
  ) -> AnyPublisher<FavoritePostToggleEntity, any Error> {
    return favoritePostInDirectoryRepository
      .toggleFavoritePost(postId: postId, directoryName: directoryName)
      .subscribe(on: backgroundQueue)
      .eraseToAnyPublisher()
  }
}
