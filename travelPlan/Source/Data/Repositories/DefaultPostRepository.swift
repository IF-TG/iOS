//
//  DefaultPostRepository.swift
//  travelPlan
//
//  Created by 양승현 on 3/8/24.
//

import Foundation
import Combine

final class DefaultPostRepository: PostRepository {
  // MAKR: - Properties
  private let service: Sessionable
  typealias Endpoint = PostAPIEndpoint
  private let loggedInUserRepository: LoggedInUserRepository
  
  private var subscriptions = Set<AnyCancellable?>()
  
  init(service: Sessionable, loggedInUserRepository: LoggedInUserRepository) {
    self.service = service
    self.loggedInUserRepository = loggedInUserRepository
  }
  
  func fetchPosts(page: Int32, perPage: Int32, category: PostCategory) -> AnyPublisher<PostsPage, Error> {
    return Future { [weak self] promise in
      guard let loggedInUserId = self?.loggedInUserRepository.id else {
        promise(.failure(LoggedInUserRepositoryError.invalidUserId))
        return
      }
      let requestDTO = PostsRequestDTO.makeRequestDTO(page: page, perPage: perPage, category: category, userId: loggedInUserId)
      let endpoint = Endpoint.fetchPosts(with: requestDTO)
      
      let subscription = self?.service.request(endpoint: endpoint)
        .mapError { MainError.networkError($0) }
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { responseDTO in
          let postContainers = responseDTO.result.map { $0.toDomain() }
          guard let totalPages = postContainers.first?.totalPosts else {
            // 반드시 필요로한 totalPage가 없는 경우
            promise(.failure(ConnectionError.missingRequiredData))
            return
          }
          let postsPage = PostsPage(
            totalPosts: totalPages,
            posts: postContainers.map { $0.post },
            thumbnails: postContainers.map { $0.thumbnail })
          promise(.success(postsPage))
        }
      self?.subscriptions.insert(subscription)
    }.eraseToAnyPublisher()
  }
  
  func fetchComments(page: Int32, perPage: Int32, postId: Int64) -> AnyPublisher<PostCommentContainerEntity, any Error> {
    let requestDTO = PostCommentsRequestDTO(page: page, perPage: perPage, postId: postId)
    let endpoint = Endpoint.fetchComments(with: requestDTO)
    return Future { [weak self] promise in
      let subscription = self?.service.request(endpoint: endpoint)
        .mapError {
          return $0.asConnectionError }
        .map { $0.result }
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { response in
          promise(.success(response.toDomain()))
        }
      self?.subscriptions.insert(subscription)
    }.eraseToAnyPublisher()
  }
  
  func fetchLikedPostsByLoggedInUser(
    page: Int32,
    perPage: Int32
  ) -> AnyPublisher<PostsPage, any Error> {
    let requestDTO = LikedPostsByLoggedInUserRequestDTO(page: page, perPage: perPage)
    let endpoint = Endpoint.fetchLikedPostsByLoggedInUser(wtih: requestDTO)
    return Future { [weak self] promise in
      let subscription = self?.service.request(endpoint: endpoint)
        .mapError { MainError.networkError($0) }
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { responseDTO in
          let postContainers = responseDTO.result.map { $0.toDomain() }
          guard let totalPages = postContainers.first?.totalPosts else {
            // 반드시 필요로한 totalPage가 없는 경우
            promise(.failure(ConnectionError.missingRequiredData))
            return
          }
          let postsPage = PostsPage(
            totalPosts: totalPages,
            posts: postContainers.map { $0.post },
            thumbnails: postContainers.map { $0.thumbnail })
          promise(.success(postsPage))
        }
      self?.subscriptions.insert(subscription)
    }.eraseToAnyPublisher()
  }
}
