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
  
  private let ownerStorage: OwnerStorage
  
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable>()
  
  // MARK: - Lifecycle
  init(service: Sessionable, ownerStorage: OwnerStorage) {
    self.service = service
    self.ownerStorage = ownerStorage
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
      
      guard let ownerId = ownerStorage.id else {
        promise(.failure(LoggedInUserRepositoryError.invalidUserId))
        return
      }
      
      let requestDTO = PostsRequestDTO.makeRequestDTO(
        page: page,
        perPage: perPage,
        category: category,
        userId: ownerId)
      let endpoint = Endpoint.fetchPosts(with: requestDTO)
      
      service.request(endpoint: endpoint)
        .mapError { MainError.networkError($0) }
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { responseDTO in
          let postContainers = responseDTO.result.map { $0.toDomain() }
          let postsPage = PostsPage(
            posts: postContainers.map { $0.post },
            thumbnails: postContainers.map { $0.thumbnail })
          promise(.success(postsPage))
        }.store(in: &subscriptions)
    }.eraseToAnyPublisher()
  }
  
  func fetchComments(
    page: Int32,
    perPage: Int32,
    postId: PostIdentifier
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
          var nestedCommentAuthorImages: [[Data?]] = []
          let commentAuthorImages: [Data?] = response.comments.enumerated().map {
            let commentAuthorImage = Data(base64Encoded: $1.userProfileURL)
            let nestedAuthorImages = $1.nestedComments.map { nestedCommentResponseDTO in
              return Data(base64Encoded: nestedCommentResponseDTO.userProfileURL)
            }
            nestedCommentAuthorImages.append(nestedAuthorImages)
            return commentAuthorImage
          }
          let entities = response.toDomain(
            with: commentAuthorImages,
            nestedCommentAuthorProfileImageDataList: nestedCommentAuthorImages)
          promise(.success(entities))
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
          let postsPage = PostsPage(
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
          let posts: [Post] = responseDTO.map { responsePostDTO in
            return responsePostDTO.toDomain()
          }
          promise(.success(posts))
        }.store(in: &subscriptions)
    }.eraseToAnyPublisher()
  }
  
  func togglePostHeart(
    postId: PostIdentifier
  ) -> AnyPublisher<Bool, any Error> {
    let requestDTO = PostCommentHeartToggleRequestDTO(id: postId)
    let endpoint = Endpoint.togglePostLike(with: requestDTO)
    return Future<Bool, any Error> { [weak self] promise in
      guard let self else {
        promise(.failure(ReferenceError.invalidReference))
        return
      }
      service.request(endpoint: endpoint)
        .mapConnectionError()
        .map { $0.result.isOnHeart }
        .sink(promise: promise, receivedValue: { result in
          promise(.success(result))
        }).store(in: &subscriptions)
    }.eraseToAnyPublisher()
  }
}
