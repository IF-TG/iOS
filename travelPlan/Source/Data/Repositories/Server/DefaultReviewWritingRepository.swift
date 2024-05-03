//
//  DefaultReviewWritingRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 4/9/24.
//

import Foundation
import Combine

final class DefaultReviewWritingRepository {
  // MARK: - Dependencies
  private let service: Sessionable
  private let backgroundQueue: DispatchQueue
  
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable?>()
  
  // MARK: - LifeCycle
  init(service: Sessionable, backgroundQueue: DispatchQueue = .global(qos: .background)) {
    self.service = service
    self.backgroundQueue = backgroundQueue
  }
}

// MARK: - ReviewWritingRepository
extension DefaultReviewWritingRepository: ReviewWritingRepository {
  func savePost(with reviewWritingPost: ReviewWritingEntity) -> AnyPublisher<Bool, any Error> {
    return Future { [weak self, backgroundQueue] promise in
      let requestDTO = ReviewWritingSaveRequestDTO.makeRequestDTO(entity: reviewWritingPost)
      
      let subscription = self?.service
        .request(endpoint: ReviewWritingEndpoints.savePost(with: requestDTO))
        .subscribe(on: backgroundQueue)
        .mapConnectionError()
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { _ in
          promise(.success(true))
        }
      self?.subscriptions.insert(subscription)
    }
    .eraseToAnyPublisher()
  }
  
  func updatePost(entity: ReviewWritingEntity, postId: String) -> AnyPublisher<Post?, any Error> {
    return Future { [weak self, backgroundQueue] promise in
      let requestDTO = ReviewWritingUpdateRequestDTO(
        postId: String(postId),
        post: ReviewWritingSaveRequestDTO.makeRequestDTO(entity: entity)
      )
      
      let subscription = self?.service.request(endpoint: ReviewWritingEndpoints.updatePost(with: requestDTO))
        .subscribe(on: backgroundQueue)
        .mapConnectionError()
        .map { $0.result }
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { responseDTO in
          
          // TODO: - responseDTO.toDomain() 사용해서 Post객체 간편화하기
          let post = Post(
            liked: responseDTO.liked,
            detail: responseDTO.toDomain(),
            author: responseDTO.toDomain(with: Data(base64Encoded: responseDTO.profile)),
            highResolveImages: responseDTO.postImages.map { $0.toDomain(with: Data(base64Encoded: $0.image)) },
            category: responseDTO.toDomain()
          )
          promise(.success(post))
        }
      self?.subscriptions.insert(subscription)
    }
    .eraseToAnyPublisher()
  }
}
