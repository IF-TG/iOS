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
  func uploadPost(content: [PostContentEntity]) -> AnyPublisher<Bool, Never> {
    return Just(true).eraseToAnyPublisher() // 임시
  }
}

struct ReviewWritingUseCaseRequestValue {
  
}
