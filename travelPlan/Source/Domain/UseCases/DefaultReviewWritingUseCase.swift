//
//  DefaultReviewWritingUseCase.swift
//  travelPlan
//
//  Created by SeokHyun on 4/9/24.
//

import Foundation
import Combine

final class DefaultReviewWritingUseCase {
  // MARK: - Properties
  private let reviewWritingRepository: any ReviewWritingRepository
  
  // MARK: - LifeCycle
  init(reviewWritingRepository: any ReviewWritingRepository) {
    self.reviewWritingRepository = reviewWritingRepository
  }
}

// MARK: - ReviewWritingUseCase
extension DefaultReviewWritingUseCase: ReviewWritingUseCase {
  func savePost(entity: ReviewWritingEntity) -> AnyPublisher<Bool, Error> {
    return reviewWritingRepository
      .savePost(with: entity)
      .eraseToAnyPublisher()
  }
  
  func updatePost(requestValue: ReviewWritingUseCaseUpdateRequestValue) 
  -> AnyPublisher<Post?, Error> {
    return reviewWritingRepository
      .updatePost(entity: requestValue.entity, postId: requestValue.postId)
      .eraseToAnyPublisher()
  }
}

struct ReviewWritingUseCaseUpdateRequestValue {
  let entity: ReviewWritingEntity
  let postId: PostIdentifier
}
