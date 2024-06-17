//
//  DefaultPostNestedCommentRepository.swift
//  travelPlan
//
//  Created by 양승현 on 3/27/24.
//

import Foundation
import Combine

final class DefaultPostNestedCommentRepository: PostNestedCommentRepository {
  typealias endpoint = PostNestedCommentAPIEndpoint
  
  // MARK: - Dependencies
  private let service: Sessionable
  private let backgroundQueue: DispatchQueue
  
  // MARK: - Properites
  private var subscriptions = Set<AnyCancellable>()
  
  // MARK: - Lifecycle
  init(service: Sessionable, backgroundQueue: DispatchQueue = DispatchQueue.global(qos: .background)) {
    self.service = service
    self.backgroundQueue = backgroundQueue
  }
  
  // MARK: - Helpers
  func sendNestedComment(
    commentId: CommentIdentifier,
    comment: String
  ) -> AnyPublisher<PostNestedCommentEntity, any Error> {
    let requestDTO = PostNestedCommentSendRequestDTO(commentId: commentId, comment: comment)
    return Future { [weak self] promise in
      guard let self else {
        promise(.failure(ReferenceError.invalidReference))
        return
      }
      
      service.request(endpoint: endpoint.sendNestedComment(with: requestDTO))
        .subscribe(on: backgroundQueue)
        .mapConnectionError()
        .map { $0.result }
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { responseDTO in
          let postNestedCommentEntity = responseDTO.toDomain(with: Data(base64Encoded: responseDTO.userProfileURL))
              promise(.success(postNestedCommentEntity))
        }.store(in: &subscriptions)
    }.eraseToAnyPublisher()
  }
  
  func updateNestedComment(
    nestedCommentId: NestedCommentIdentifier,
    comment: String
  ) -> AnyPublisher<Bool, any Error> {
    let requestDTO = PostNestedCommentUpdateRequestDTO(nestedCommentId: nestedCommentId, comment: comment)
    return Future { [weak self] promise in
      guard let self else {
        promise(.failure(ReferenceError.invalidReference))
        return
      }
      
      service.request(endpoint: endpoint.updateNestedComment(with: requestDTO))
        .subscribe(on: backgroundQueue)
        .mapConnectionError()
        .map { $0.result }
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { responseDTO in
          if nestedCommentId == responseDTO.nestedCommentId {
            promise(.success(true))
            return
          }
          promise(.success(false))
        }.store(in: &subscriptions)
    }.eraseToAnyPublisher()
  }
  
  func deleteNestedComment(nestedCommentId: NestedCommentIdentifier) -> AnyPublisher<DeletedNestedCommentResult, any Error> {
    let requestDTO = PostNestedCommentDeleteRequestDTO(nestedCommentId: nestedCommentId)
    return Future { [weak self] promise in
      guard let self else {
        promise(.failure(ReferenceError.invalidReference))
        return
      }
      
      service.request(endpoint: endpoint.deleteNestedComment(with: requestDTO))
        .subscribe(on: backgroundQueue)
        .mapConnectionError()
        .map { $0.result }
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { _ in
          promise(.success(.justANestedCommentDeleted))
        }.store(in: &subscriptions)
    }.eraseToAnyPublisher()
  }
  
  func toggleCommentHeart(nestedCommentId: NestedCommentIdentifier) -> AnyPublisher<ToggledPostCommentHeartEntity, any Error> {
    let requestDTO = PostNestedCommentHeartToggleRequestDTO(id: nestedCommentId)
    let endpoint = endpoint.toggleCommentHeart(with: requestDTO)
    return Future { [weak self] promise in
      guard let self else {
        promise(.failure(ReferenceError.invalidReference))
        return
      }
      
      service.request(endpoint: endpoint)
        .subscribe(on: backgroundQueue)
        .mapConnectionError()
        .map { $0.result }
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { result in
          promise(.success(result.toDomain()))
        }.store(in: &subscriptions)
    }.eraseToAnyPublisher()
  }
}
