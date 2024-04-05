//
//  DefaultPostRepository.swift
//  travelPlan
//
//  Created by 양승현 on 3/8/24.
//

import Foundation
import Combine

final class DefaultPostRepository {
  typealias Endpoint = PostAPIEndpoint
  // MARK: - Dependencies
  private let service: Sessionable
  
  private let loggedInUserRepository: LoggedInUserRepository
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable>()
  
  // MARK: - Lifecycle
  init(service: Sessionable, loggedInUserRepository: LoggedInUserRepository) {
    self.service = service
    self.loggedInUserRepository = loggedInUserRepository
  }
}

// MARK: - PostRepository 
extension DefaultPostRepository: PostRepository {
  func fetchPosts(
    page: Int32,
    perPage: Int32,
    category: PostCategory
  ) -> AnyPublisher<PostsPage, Error> {
    return Future { [weak self] promise in
      guard let self else {
        promise(.failure(ReferenceError.invalidReference))
        return
      }
      
      guard let loggedInUserId = loggedInUserRepository.id else {
        promise(.failure(LoggedInUserRepositoryError.invalidUserId))
        return
      }
      
      let requestDTO = PostsRequestDTO.makeRequestDTO(
        page: page,
        perPage: perPage,
        category: category,
        userId: loggedInUserId)
      let endpoint = Endpoint.fetchPosts(with: requestDTO)
      
      service.request(endpoint: endpoint)
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
        }.store(in: &subscriptions)
    }.eraseToAnyPublisher()
  }
  
  func fetchComments(
    page: Int32,
    perPage: Int32,
    postId: Int64
  ) -> AnyPublisher<PostCommentContainerEntity, any Error> {
    let requestDTO = PostCommentsRequestDTO(page: page, perPage: perPage, postId: postId)
    let endpoint = Endpoint.fetchComments(with: requestDTO)
    return Future { [weak self] promise in
      guard let self else {
        promise(.failure(ReferenceError.invalidReference))
        return
      }
      
      service.request(endpoint: endpoint)
        .mapError {
          return $0.asConnectionError }
        .map { $0.result }
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { response in
          promise(.success(response.toDomain()))
        }.store(in: &subscriptions)
    }.eraseToAnyPublisher()
  }
  
  func fetchLikedPostsByLoggedInUser(
    page: Int32,
    perPage: Int32
  ) -> AnyPublisher<PostsPage, any Error> {
    let requestDTO = LikedPostsByLoggedInUserRequestDTO(page: page, perPage: perPage)
    let endpoint = Endpoint.fetchLikedPostsByLoggedInUser(wtih: requestDTO)
    return Future { [weak self] promise in
      guard let self else {
        promise(.failure(ReferenceError.invalidReference))
        return
      }
      service.request(endpoint: endpoint)
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
        }.store(in: &subscriptions)
    }.eraseToAnyPublisher()
  }
  
  func searchPosts(
    keyword: String,
    page: Int32, 
    perPage: Int32,
    isTitle: Bool,
    isContent: Bool
  ) -> AnyPublisher<[Post], any Error> {
    let requestDTO = PostSearchRequestDTO(
      keyword: keyword,
      isTitle: isTitle,
      isContent: isContent,
      page: page, 
      perPage: perPage)
    let endpoint = Endpoint.searchPosts(with: requestDTO)
    return Future { [weak self] promise in
      guard let self else {
        promise(.failure(ReferenceError.invalidReference))
        return
      }
      service.request(endpoint: endpoint)
        .mapConnectionError()
        .map { $0.result }
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { responseDTO in
          
        }.store(in: &subscriptions)
    }.eraseToAnyPublisher()
  }
}
