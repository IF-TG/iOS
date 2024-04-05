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
    self.favoritePostInDirectoryRepository = DefaultFavoritePostInDirectoryRepository(service: mockService)
  }
  
  func fetchFavoritePosts(
    name directoryName: String,
    page: Int32,
    perPage: Int32
  ) -> AnyPublisher<[Post], any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mock = MockResponseType.favoriteDirectory(.favoritePost(.whenFavoritePostsFetch)).mockDataLoader
      return ((.init(), mock))
    }
    return Future { promise in
      DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.3) { [weak self] in
        let subscription = self?.favoritePostInDirectoryRepository
          .fetchFavoritePosts(name: directoryName, page: page, perPage: perPage)
          .sink { completion in
            if case .failure(let error) = completion {
              promise(.failure(error))
            }
          } receiveValue: { posts in
            promise(.success(posts))
          }
        self?.subscriptions.insert(subscription)
      }
    }.eraseToAnyPublisher()
  }
  
  func toggleFavoritePost(
    postId: Int64,
    directoryName: String
  ) -> AnyPublisher< FavoritePostToggleEntity, any Error> {
    return Just(.init(postId: postId, isScrapped: true))
      .delay(for: .seconds(0.5), scheduler: DispatchQueue.global(qos: .background))
      .setFailureType(to: Error.self)
      .eraseToAnyPublisher()
  }
  
  func updateFolderName(
    postIdList: [Int64],
    directoryName: String
  ) -> AnyPublisher<UpdatedFavoritePostDirectoryName, any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mock = MockResponseType.favoriteDirectory(
        .favoritePost(.whenFavoritePostDirectoryNameUpdate)
      ).mockDataLoader
      return ((.init(), mock))
    }
    
    return Future { promise in
      DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.3) { [weak self] in
        let subscription = self?.favoritePostInDirectoryRepository
          .updateFolderName(postIdList: postIdList, directoryName: directoryName)
          .sink { completion in
            if case .failure(let error) = completion {
              promise(.failure(error))
            }
          } receiveValue: { entity in
            let interceptedEntity = UpdatedFavoritePostDirectoryName(
              directoryId: 1,
              userId: 1,
              directoryname: directoryName)
            promise(.success(interceptedEntity))
          }
        self?.subscriptions.insert(subscription)
      }
    }.eraseToAnyPublisher()
  }
}
