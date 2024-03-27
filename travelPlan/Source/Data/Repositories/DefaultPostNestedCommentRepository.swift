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
  private var subscriptions = Set<AnyCancellable?>()
  
  // MARK: - Lifecycle
  init(service: Sessionable, backgroundQueue: DispatchQueue = DispatchQueue.global(qos: .background)) {
    self.service = service
    self.backgroundQueue = backgroundQueue
  }
  
  // MARK: - Helpers
  func sendNestedComment(
    commentId: Int64,
    comment: String
  ) -> Future<PostNestedCommentEntity, any Error> {
    let requestDTO = PostNestedCommentSendRequestDTO(commentId: commentId, comment: comment)
    return Future { [weak self] promise in
      guard let backgroundQueue = self?.backgroundQueue else {
        promise(.failure(ReferenceError.invalidReference))
        return
      }
      let subscription = self?.service
        .request(endpoint: endpoint.sendNestedComment(with: requestDTO))
        .subscribe(on: backgroundQueue)
        .mapConnectionError()
        .map { $0.result }
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { responseDTO in
              let postNestedCommentEntity = responseDTO.toDomain()
              promise(.success(postNestedCommentEntity))
        }
      self?.subscriptions.insert(subscription)
    }
  }
  
  func updateNestedComment(
    nestedCommentId: Int64,
    comment: String
  ) -> Future<Bool, any Error> {
    let requestDTO = PostNestedCommentUpdateRequestDTO(nestedCommentId: nestedCommentId, comment: comment)
    return Future { [weak self] promise in
      guard let backgroundQueue = self?.backgroundQueue else {
        promise(.failure(ReferenceError.invalidReference))
        return
      }
      let subscription = self?.service
        .request(endpoint: endpoint.updateNestedComment(with: requestDTO))
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
        }
      self?.subscriptions.insert(subscription)
    }
  }
}
