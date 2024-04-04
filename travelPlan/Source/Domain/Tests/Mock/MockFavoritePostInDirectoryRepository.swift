//
//  MockFavoritePostInDirectoryRepository.swift
//  travelPlan
//
//  Created by 양승현 on 4/4/24.
//

import Foundation
import Combine

final class MockFavoritePostInDirectoryRepository: FavoritePostInDirectoryRepository {
  private typealias Endpoint = FavoritePostAPIEndpoint
  private let mockService: Sessionable
  private var subscriptions = Set<AnyCancellable?>()
  private let favoritePostInDirectoryRepository: FavoritePostInDirectoryRepository
  
  init() {
    self.mockService = SessionProvider(session: MockSession.default)
    self.favoritePostInDirectoryRepository = DefaultFavoritePostInDirectoryUseCase(favoritePostInDirectoryRepository: <#T##any FavoritePostInDirectoryRepository#>)
  }
  
  func fetchFavoritePosts(
    name directoryName: String,
    page: Int32,
    perPage: Int32
  ) -> AnyPublisher<[Post], any Error> {
    <#code#>
  }
}
