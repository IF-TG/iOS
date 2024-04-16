//
//  ReviewWritingUseCase.swift
//  travelPlan
//
//  Created by SeokHyun on 4/9/24.
//

import Foundation
import Combine

protocol ReviewWritingUseCase {
  func savePost(entity: ReviewWritingEntity) -> AnyPublisher<Bool, Error>
  func updatePost(requestValue: ReviewWritingUseCaseUpdateRequestValue) -> AnyPublisher<Post, Error>
}
