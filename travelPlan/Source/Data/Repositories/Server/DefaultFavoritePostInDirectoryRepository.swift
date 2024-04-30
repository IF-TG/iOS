//
//  DefaultFavoritePostInDirectoryRepository.swift
//  travelPlan
//
//  Created by 양승현 on 4/4/24.
//

import Foundation
import Combine

final class DefaultFavoritePostInDirectoryRepository {
  typealias Endpoint = FavoritePostAPIEndpoint
  
  // MARK: - Dependencies
  private let service: Sessionable
  private let backgroundQueue: DispatchQueue
  
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable>()
  
  // MARK: - Lifecycle
  init(service: Sessionable, backgroundQueue: DispatchQueue = .global(qos: .default)) {
    self.service = service
    self.backgroundQueue = backgroundQueue
  }
}

// MARK: - FavoritePostInDirectoryRepository
extension DefaultFavoritePostInDirectoryRepository: FavoritePostInDirectoryRepository {
  func fetchFavoritePosts(
    name directoryName: String,
    page: Int32,
    perPage: Int32
  ) -> AnyPublisher<[Post], any Error> {
    let requestDTO = FavoritePostRequestDTO(folderName: directoryName, page: page, perPage: perPage)
    return Future { [weak self] promise in
      guard let self else {
        promise(.failure(ReferenceError.invalidReference))
        return
      }
      
      service.request(endpoint: Endpoint.fetchFavoritePosts(with: requestDTO))
        .subscribe(on: backgroundQueue)
        .mapConnectionError()
        .map { commonDTO in return commonDTO.result }
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { postResponseDTOs in
          let posts = postResponseDTOs.map {
            return Post(
              liked: $0.liked,
              detail: $0.toDomain(),
              author: $0.toDomain(with: Data(base64Encoded: $0.profile)),
              highResolveImages: $0.postImages.map { $0.toDomain(with: Data(base64Encoded: $0.image)) },
              category: $0.toDomain())}
          promise(.success(posts))
        }.store(in: &subscriptions)
    }.eraseToAnyPublisher()
  }
  
  func toggleFavoritePost(
    postId: Int64,
    directoryName: String
  ) -> AnyPublisher<FavoritePostToggleEntity, any Error> {
    let requestDTO = FavoritePostScrapRequestDTO(objectId: postId, folderName: directoryName)
    return Future { [weak self] promise in
      guard let self else {
        promise(.failure(ReferenceError.invalidReference))
        return
      }

      service.request(endpoint: Endpoint.toggleFavoritePost(with: requestDTO))
        .subscribe(on: backgroundQueue)
        .mapConnectionError()
        .map { $0.result }
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { responseDTO in
          promise(.success(responseDTO.toDomain()))
        }.store(in: &subscriptions)
    }.eraseToAnyPublisher()
  }
  
  func updateFolderName(
    postIdList: [Int64],
    directoryName: String
  ) -> AnyPublisher<UpdatedFavoritePostDirectoryName, any Error> {
    let requestDTO = FavoritePostDirectoryNameUpdateRequestDTO(
      postIdList: postIdList,
      folderName: directoryName)

    return Future { [weak self] promise in
      guard let self else {
        promise(.failure(ReferenceError.invalidReference))
        return
      }
      
      service.request(endpoint: Endpoint.updateFolderName(with: requestDTO))
        .subscribe(on: backgroundQueue)
        .mapConnectionError()
        .map { $0.result }
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { responseDTO in
          promise(.success(responseDTO.toDomain()))
        }.store(in: &subscriptions)
    }.eraseToAnyPublisher()

  }
}
