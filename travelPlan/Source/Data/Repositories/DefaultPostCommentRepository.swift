//
//  DefaultPostCommentRepository.swift
//  travelPlan
//
//  Created by 양승현 on 3/23/24.
//

import Foundation
import Combine

final class DefaultPostCommentRepository: PostCommentRepository {
  // MARK: - Dependencies
  private let service: Sessionable
  private let backgroundQueue: DispatchQueue
  typealias endpoint = PostCommentAPIEndpoint
  
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable>()
  
  // MARK: - Lifecycle
  init(service: Sessionable, backgroundQueue: DispatchQueue = .global(qos: .default)) {
    self.service = service
    self.backgroundQueue = backgroundQueue
  }
  
  func sendComment(postId: Int64, comment: String) -> AnyPublisher<PostCommentEntity, any Error> {
    let requestDTO = PostCommentSendingRequestDTO(postId: postId, comment: comment)
    return Future { [weak self] promise in
      guard let self else {
        promise(.failure(ReferenceError.invalidReference))
        return
      }
      service.request(endpoint: endpoint.sendComment(with: requestDTO))
        .subscribe(on: backgroundQueue)
        .mapConnectionError()
        .map { $0.result }
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { responseDTO in
          let postCommentEntity = responseDTO.toDomain()
          promise(.success(postCommentEntity))
        }.store(in: &subscriptions)
    }.eraseToAnyPublisher()
  }
  
  func updateComment(commentId: Int64, comment: String) -> AnyPublisher<UpdatedPostCommentEntity, any Error> {
    let requestDTO = PostCommentUpdateRequestDTO(commentId: commentId, comment: comment)
    return Future { [weak self] promise in
      guard let self else {
        promise(.failure(ReferenceError.invalidReference))
        return
      }
      
      service.request(endpoint: endpoint.updateComment(with: requestDTO))
        .subscribe(on: backgroundQueue)
        .mapConnectionError { $0 }
        .map { $0.result }
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { responseDTO in
          let updatedPostCommentEntity = responseDTO.toDomain()
          promise(.success(updatedPostCommentEntity))
        }.store(in: &subscriptions)
    }.eraseToAnyPublisher()
  }
  
  func deleteComment(commentId: Int64) -> AnyPublisher<Bool, any Error> {
    let requestDTO = PostCommentDeleteRequestDTO(commentId: commentId)
    return Future { [weak self] promise in
      guard let self else {
        promise(.failure(ReferenceError.invalidReference))
        return
      }
      
      service.request(endpoint: endpoint.deleteComment(with: requestDTO))
        .subscribe(on: backgroundQueue)
        .mapConnectionError { $0 }
        .map { $0.result }
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { result in
          promise(.success(result))
        }.store(in: &subscriptions)
    }.eraseToAnyPublisher()
  }
  
  func fetchComments(
    page: Int32,
    perPage: Int32,
    postId: Int64
  ) -> AnyPublisher<[PostCommentEntity], any Error> {
    let requestDTO = PostCommentsRequestDTO(page: page, perPage: perPage, postId: postId)
    return Future { [weak self] promise in
      guard let self else {
        promise(.failure(ReferenceError.invalidReference))
        return
      }
      
      service.request(endpoint: endpoint.fetchComments(with: requestDTO))
        .subscribe(on: backgroundQueue)
        .mapConnectionError { $0 }
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { responseDTO in
          promise(.success(responseDTO.map { $0.toDomain() }))
        }.store(in: &subscriptions)
    }.eraseToAnyPublisher()
  }
  
  func toggleCommentHeart(
    commentId: Int64
  ) -> AnyPublisher<ToggledPostCommentHeartEntity, any Error> {
    let requestDTO = PostCommentHeartToggleRequestDTO(id: commentId)
    return Future { [weak self] promise in
      guard let self else {
        promise(.failure(ReferenceError.invalidReference))
        return
      }
      
      service.request(endpoint: endpoint.toggleCommentHeart(with: requestDTO))
        .subscribe(on: backgroundQueue)
        .mapConnectionError { $0 }
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
