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
  private var subscriptions = Set<AnyCancellable?>()
  
  // MARK: - Lifecycle
  init(service: Sessionable, backgroundQueue: DispatchQueue = .global(qos: .default)) {
    self.service = service
    self.backgroundQueue = backgroundQueue
  }
  
  func sendComment(postId: Int64, comment: String) -> Future<PostCommentEntity, any Error> {
    let requestDTO = PostCommentSendingRequestDTO(postId: postId, comment: comment)
    return Future { [weak self] promise in
      guard let backgroundQueue = self?.backgroundQueue else {
        promise(.failure(ReferenceError.invalidReference))
        return
      }
      let subscription = self?.service.request(endpoint: endpoint.sendComment(with: requestDTO))
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
        }
      self?.subscriptions.insert(subscription)
    }
  }
}
