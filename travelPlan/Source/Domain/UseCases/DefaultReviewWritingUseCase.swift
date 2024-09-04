//
//  DefaultReviewWritingUseCase.swift
//  travelPlan
//
//  Created by SeokHyun on 4/9/24.
//

import Foundation
import Photos
import Combine

final class DefaultReviewWritingUseCase {
  // MARK: - Dependencies
  private let reviewWritingRepository: any ReviewWritingRepository
  private let photoAuthRepository: any PhotoAuthorizationRepository
  
  // MARK: - LifeCycle
  init(
    reviewWritingRepository: any ReviewWritingRepository,
    photoAuthRepository: any PhotoAuthorizationRepository
  ) {
    self.reviewWritingRepository = reviewWritingRepository
    self.photoAuthRepository = photoAuthRepository
  }
}

// MARK: - ReviewWritingUseCase
extension DefaultReviewWritingUseCase: ReviewWritingUseCase {
  func savePost(entity: ReviewWritingEntity) -> AnyPublisher<Bool, any Error> {
    return reviewWritingRepository
      .savePost(with: entity)
      .eraseToAnyPublisher()
  }
  
  func updatePost(requestValue: ReviewWritingUseCaseUpdateRequestValue) 
  -> AnyPublisher<Post?, any Error> {
    return reviewWritingRepository
      .updatePost(entity: requestValue.entity, postId: requestValue.postId)
      .eraseToAnyPublisher()
  }
  
  func requestAuthorization() -> AnyPublisher<PHAuthorizationStatus, Never> {
    return photoAuthRepository.requestAuthorization()
  }
}

struct ReviewWritingUseCaseUpdateRequestValue {
  let entity: ReviewWritingEntity
  let postId: PostIdentifier
}
